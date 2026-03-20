module ApiResponder
  extend ActiveSupport::Concern

  private

  # success response
  def json_response(data, status = :ok, message = nil)
    render json: {
      success: true,
      message: message,
      data: data
    }, status: status
  end

  # error response
  def error_response(message, status, errors = nil)
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: status
  end
end
