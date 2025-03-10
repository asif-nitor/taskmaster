require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { create(:task, assigned_to: user) }

  describe '#associations' do
    it 'belongs to assigned_to as User' do
      assoc = Task.reflect_on_association(:assigned_to)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:class_name]).to eq('User')
      expect(assoc.options[:foreign_key]).to eq('assigned_to_id')
    end
  end

  describe '#enums' do
    it 'defines status #enum with correct values' do
      expect(Task.statuses).to eq('pending' => 0, 'in_progress' => 1, 'completed' => 2)
    end
  end
  
end
