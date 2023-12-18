class ApplicationController < ActionController::API
  rescue_from StandardError do |exception|
    handle_exception(exception)
  end

  private

  def handle_exception(exception)
    prepared_error = ErrorHandler.call(exception)

    # we can provide more details into logs for better troubleshooting
    Rails.logger.error("[ERROR] [#{prepared_error}] #{prepared_error.to_json_api}")

    render_error(prepared_error, prepared_error.status_code)
  end

  def render_error(error, status = nil)
    render json: error.to_json_api, status: status.presence || error.status_code
  end
end
