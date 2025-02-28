module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :authenticate_api_v1_user!, only: [:create]
      respond_to :json

      def create
        user = User.new(sign_up_params)
        if user.save
          token = Warden::JWTAuth::UserEncoder.new.call(user, nil, nil)[0]
          user.role = params[:user][:role] if params[:user][:role].present?
          render json: { token: token, user: { email: user.email, role: user.role } }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :role)
      end
    end
  end
end