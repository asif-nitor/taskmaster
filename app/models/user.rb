class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :tasks, foreign_key: 'assigned_to_id'

  enum role: %w{user manager admin}

  def jwt_payload
    super
  end

  self::roles.keys.each do |k|
    define_method "#{k}?" do
      role == k
    end
  end
end
