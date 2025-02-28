module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy]
      # after_action :verify_authorized, except: :index
      # after_action :verify_policy_scoped, only: :index

      def index
        @tasks = policy_scope(Task)
        render json: @tasks
      end

      def show
        authorize @task
        render json: @task
      end

      def create
        @task = Task.new(task_params)
        authorize @task
        if @task.save
          render json: @task, status: :created
          # TaskMailer.assigned_task(@task.assigned_to, @task).deliver_later
          ActionCable.server.broadcast(
            "tasks_#{@task.assigned_to_id}",  # First argument: channel name
            {                                 # Second argument: data hash
              action: 'task_assigned',
              task: task_response(@task),
              message: "Task '#{@task.title}' has been assigned to you by Admin"
            }
          )
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      def update
        authorize @task
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @task
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :due_date, :assigned_to_id)
      end

      def task_response(task)
        { id: task.id, title: task.title }
      end
    end
  end
end