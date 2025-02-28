class PendingTasksWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'mailers'  # Optional: Use a dedicated queue

  def perform
    User.find_each do |user|
      pending_tasks = user.tasks.where(status: 'pending')
      if pending_tasks.any?
        TaskMailer.pending_tasks_notification(user, pending_tasks).deliver_later
      end
    end
  end
end