class ApplicationController < ActionController::API
  include Pundit::Authorization

  attr_reader :current_user

  before_action :authenticate, except: :login

  rescue_from StandardError do |exception|
    handle_exception(exception)
  end

  def login
    auth_params = params.permit(:email, :password)
    user = User.find_by(email: auth_params[:email])

    if user&.authenticate(auth_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { auth_token: token }, status: :ok
    else
      render_error(Errors::Unauthorized.new('Invalid credentials.'))
    end
  end

  private

  def authenticate
    header = request.headers['Authorization']
    header = header.split(' ').last if header.present?

    if header.present? && (decoded = JsonWebToken.decode(header))
      @current_user = User.find(decoded[:user_id])
    else
      render_error(Errors::Unauthorized.new('Unauthorized request. Authentication is required.'))
    end
  end

  def handle_exception(exception)
    prepared_error = ErrorHandler.call(exception)

    # we can provide more details into logs for better troubleshooting.
    Rails.logger.error("[ERROR] [#{prepared_error.class.name}] #{prepared_error.to_json_api}")

    render_error(prepared_error, prepared_error.status_code)
  end

  def render_error(error, status = nil)
    render json: error.to_json_api, status: status.presence || error.status_code
  end

  def validate(contract_class = BaseContract, **options)
    contract = contract_class.new(**options).call(params.to_unsafe_h)
    raise Errors::UnprocessableEntity.new(*contract_class.errors_to_a(contract)) if contract.failure?

    contract.to_h
  end

  def handle_service(service_class = BaseService, **params)
    service = service_class.new(**params).call
    raise service[:error] unless service[:success]

    service[:value]
  end
end
