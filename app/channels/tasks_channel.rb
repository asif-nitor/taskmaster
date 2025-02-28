class TasksChannel < ApplicationCable::Channel
  def subscribed
    # Stream notifications specific to the current user
    stream_from "tasks_#{current_user.id}"
  end

  def unsubscribed
  end

  private

  def current_user
    connection.current_api_v1_user
  end
end