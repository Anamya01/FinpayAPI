module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        include ActionController::MimeResponds
        include ApiResponder
        include ErrorHandler
        respond_to :json
        before_action :authenticate_user!, only: [ :show, :update, :destroy ]

        def show
          json_response(data: current_user)
        end

        def create
          user = User.create!(user_params.merge(role: :member))

          json_response(
            data: user,
            status: :created,
            message: I18n.t("auth.registrations.create.success")
          )
        end

        def update
          # Devise specific method to update
          current_user.update_with_password(account_update_params)
          json_response(data: current_user, status: :ok, message: I18n.t("auth.registrations.update.success"))
        end

        def destroy
          current_user.destroy
          json_response(data: nil, status: :ok, message: I18n.t("auth.registrations.destroy.success"))
        end

        private
        def user_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

        def account_update_params
          params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
        end
      end
    end
  end
end
