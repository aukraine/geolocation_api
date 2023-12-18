class ApplicationController < ActionController::API
  include Pundit::Authorization

  attr_reader :current_user

  before_action :authenticate, except: :login

  rescue_from StandardError do |exception|
    handle_exception(exception)
  end

  def login; end

  private

  def authenticate
    @current_user = User.last
  end

  def handle_exception(exception)
    prepared_error = ErrorHandler.call(exception)

    # we can provide more details into logs for better troubleshooting.
    Rails.logger.error("[ERROR] [#{prepared_error}] #{prepared_error.to_json_api}")

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
end
