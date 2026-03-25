module Api
  module V1
    class BaseController < ApplicationController
    include ActionController::MimeResponds
    include PaginationMetadata
    include ApiResponder
    include ErrorHandler
    respond_to :json
    end
  end
end
