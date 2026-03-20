module ApiResponder
  extend ActiveSupport::Concern

  included do
    # Centralized error handling
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :bad_request
  end

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

  # Error handlers mapped to specific status codes
  def not_found(exception)
    error_response(exception.message, :not_found)
  end

  def unprocessable_entity(exception)
    error_response("Validation failed", :unprocessable_entity, exception.record.errors.full_messages)
  end

  def bad_request(exception)
    error_response(exception.message, :bad_request)
  end
end
