class TaskMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def pending_tasks_notification(user, tasks)
    @user = user
    @tasks = tasks
    mail(to: @user.email, subject: 'Your Pending Tasks - Daily Reminder')
  end

  def assigned_task(user, tasks)
    @user = user
    @tasks = tasks
    mail(to: @user.email, subject: 'New Task Assigned')
  end

end