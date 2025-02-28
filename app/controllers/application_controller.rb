class ApplicationController < ActionController::API

  before_action :authenticate_api_v1_user!
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def pundit_user
    current_api_v1_user
  end

  def user_not_authorized
    render json: { alert: ['You are not authorized to perform this operation.'] }, status: :forbidden
  end

end
