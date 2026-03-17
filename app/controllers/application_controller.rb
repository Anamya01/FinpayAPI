class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include PaginationMetadata
    respond_to :json
end
