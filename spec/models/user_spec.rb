require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:manager) { create(:user, :manager) }
  let(:admin) { create(:user, :admin) }

  describe 'associations' do
    # it { should have_many(:tasks) }
    # it { should have_many(:tasks).with_foreign_key(:assigned_to_id) }
    # expect(User.reflect_on_association(:tasks).macro).to eq(:has_many)
    # expect(User.reflect_on_association(:tasks).options[:foreign_key]).to eq('assigned_to_id')
  end

  # describe 'validations' do
  #   subject { build(:user) }
  #   it { is_expected.to validate_presence_of(:email) }
  #   it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  #   it { is_expected.to validate_presence_of(:password) }
  #   it { is_expected.to validate_length_of(:password).is_at_least(6) }
  # end

  describe 'enums' do
    it 'defines role enum with correct values' do
      expect(User.roles).to eq('user' => 0, 'manager' => 1, 'admin' => 2)
    end
  end

  describe 'dynamic role methods' do
    context 'with #user? role' do
      it 'returns true for user? and false for others' do
        expect(user.user?).to be true
        expect(user.manager?).to be false
        expect(user.admin?).to be false
      end
    end

    context 'with #manager? role' do
      it 'returns true for manager? and false for others' do
        expect(manager.manager?).to be true
        expect(manager.user?).to be false
        expect(manager.admin?).to be false
      end
    end

    context 'with #admin? role' do
      it 'returns true for admin? and false for others' do
        expect(admin.admin?).to be true
        expect(admin.user?).to be false
        expect(admin.manager?).to be false
      end
    end
  end

  describe 'Devise modules' do
    it 'includes expected Devise modules' do
      expect(User.devise_modules).to include(
        :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :validatable,
        :jwt_authenticatable
      )
    end

    it 'sets #jwt_revocation_strategy to JTIMatcher' do
      expect(User.jwt_revocation_strategy).to eq(User)
    end
  end

  describe '#jwt_payload' do
    it 'returns a hash with jti' do
      expect(user.jwt_payload).to be_a(Hash)
      expect(user.jwt_payload['jti']).to eq(user.jti)
    end
  end

end
