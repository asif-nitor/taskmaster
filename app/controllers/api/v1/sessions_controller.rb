module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :authenticate_api_v1_user!, only: [:create]
      respond_to :json

      def create
        user = User.find_by(email: params[:user][:email])
        if user&.valid_password?(params[:user][:password])
          sign_in(user)
          token = Warden::JWTAuth::UserEncoder.new.call(user, nil, nil)[0]
          render json: { token: token, user: { email: user.email, role: user.role } }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def destroy
        if current_api_v1_user
          token = request.headers['Authorization']&.split(' ')&.last
          signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
          if signed_out
            render json: { message: 'Signed out successfully' }, status: :ok
          else
            render json: { error: 'Failed to sign out' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Not signed in' }, status: :unprocessable_entity
        end
      end

    end
  end
end