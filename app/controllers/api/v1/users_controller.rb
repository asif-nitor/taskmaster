module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :destroy]
      def index
        @users = policy_scope(User)
        render json: @users.map { |u| user_response(u) }
      end

      def show
        authorize @user
        render json: user_response(@user)
      end

      def destroy
        authorize @user
        @user.destroy
        head :no_content
      end

      private

      def set_user
        binding.pry
        @user = User.find(params[:id])
      end

      def user_response(user)
        { id: user.id, email: user.email, role: user.role }
      end
    end
  end
end