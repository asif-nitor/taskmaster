module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_api_v1_user

    def connect
      self.current_api_v1_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token] || request.headers['Authorization']&.split(' ')&.last
      if token
        decoded = Warden::JWTAuth::UserDecoder.new.call(token)
        User.find(decoded['sub']) rescue reject_unauthorized_connection
      else
        reject_unauthorized_connection
      end
    end
  end
end
