module Auth
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json
    before_action :authenticate_user!, only: [ :show, :update, :destroy ]

    def show
      render json: current_user
    end

    def create
      user = User.create!(
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        role: :member
      )

      render json: {
        message: "User created successfully",
        user: user
      }, status: :created
    end

    def update
      # Devise specific method to update
      if current_user.update_with_password(account_update_params)
        render json: current_user
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.destroy
      render json: { message: "User account deleted successfully" }, status: :ok
    end

    private
    def account_update_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
    end
  end
end
