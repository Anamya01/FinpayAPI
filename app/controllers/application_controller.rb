class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include PaginationMetadata
    include ApiResponder
    respond_to :json
end
