class Task < ApplicationRecord

  belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id'

  enum status: %w{pending in_progress completed}
end
