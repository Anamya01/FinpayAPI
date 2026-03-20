class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include PaginationMetadata
    include ApiResponder
    include ErrorHandler
    respond_to :json
end
