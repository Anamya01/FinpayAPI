module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        include ActionController::MimeResponds
        include ApiResponder
        include ErrorHandler
        respond_to :json
        skip_before_action :verify_signed_out_user, only: [ :destroy ]
        # Issue : The company swithcer middleware is switching back to public even before warden can revoke the token.
        # therefore its unable to find user and throwing error.
        def destroy
          current_user.update_column(:jti, SecureRandom.uuid) if current_user
          super
        end
      end
    end
  end
end
