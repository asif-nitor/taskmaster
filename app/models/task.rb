class Task < ApplicationRecord

  belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id'
  belongs_to :assigned_by, class_name: 'User', foreign_key: 'assigned_by_id'

  enum status: %w{pending in_progress completed}
  validates :title, :description, :due_date, presence: true
  scope :notify_pending_task, -> { (where('due_date > ? AND due_date <= ?', Date.today, Date.today + 25.days)) }

  def as_json(options = {})
    super(options.merge(
      include: {
        assigned_to: { only: [:id, :email] },
        assigned_by: { only: [:id, :email] }
      }
    ))
  end
end
