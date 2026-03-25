# Can be used if needed
class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end

  private

  def success(data = nil, message: nil)
    {
      success: true,
      data: data,
      message: message
    }
  end

  def failure(message:, code: nil)
    {
      success: false,
      error: message,
      code: code
    }
  end
end
