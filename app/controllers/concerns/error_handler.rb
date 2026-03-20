module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :bad_request
  end

  private

  def record_not_found(e)
    error_response(e.message, :not_found)
  end

  def render_unprocessable_entity(e)
    error_response("Validation Failed", :unprocessable_entity, e.record.errors.full_messages)
  end

  def bad_request(exception)
    error_response(exception.message, :bad_request)
  end
end
