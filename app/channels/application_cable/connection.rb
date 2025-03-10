module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token] || request.headers['Authorization']&.split(' ')&.last
      if token
        decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true)
        jti = decoded_token.first['jti']
        user = User.find_by(jti: jti) rescue reject_unauthorized_connection
        # decoded = Warden::JWTAuth::UserDecoder.new.call(token)
        # User.find(decoded['sub']) rescue reject_unauthorized_connection
      else
        reject_unauthorized_connection
      end
    end
  end
end


# # app/channels/application_cable/connection.rb
# module ApplicationCable
#   class Connection < ActionCable::Connection::Base
#     identified_by :current_user

#     def connect
#       self.current_user = find_verified_user
#       reject_unauthorized_connection unless current_user
#     end

#     private

#     def find_verified_user
#       token = request.params[:token] || request.headers['Authorization']&.split(' ')&.last
#       return nil unless token

#       begin
#         # Provide all 3 arguments: token, namespace, purpose
#         decoded = Warden::JWTAuth::UserDecoder.new.call(token, :user, Warden::JWTAuth::TokenDecoder::USER_AUTH)
#         User.find(decoded['sub'])
#       rescue StandardError => e
#         Rails.logger.error "WebSocket Authentication Error: #{e.message}"
#         nil
#       end
#     end
#   end
# end