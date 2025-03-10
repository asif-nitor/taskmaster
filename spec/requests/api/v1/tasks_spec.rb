# require 'rails_helper'

# RSpec.describe "Api::V1::Tasks", type: :request do

#   let(:admin) { create(:user, :admin) }
#   let(:manager) { create(:user, :manager) }
#   let(:user) { create(:user) }

#   describe "GET /api/v1/tasks" do
#     pending "add some examples (or delete) #{__FILE__}"
#   end
# end

require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  let(:admin) { create(:user, role: 'admin') }
  let(:manager) { create(:user, role: 'manager') }
  let(:user) { create(:user) }
  let(:assigned_user) { create(:user) }
  let(:task) { create(:task, assigned_to: assigned_user) }
  let(:headers) { { 'Authorization' => "Bearer #{jwt_token(admin)}", 'Content-Type' => 'application/json' } }

  def jwt_token(user)
    JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
  end

  describe "GET /api/v1/tasks" do
    it "returns all tasks for an admin" do
      create_list(:task, 5)
      get "/api/v1/tasks", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  # describe "GET /api/v1/tasks/:id" do
  #   it "returns the task details for an authorized user" do
  #     get "/api/v1/tasks/#{task.id}", headers: headers
  #     expect(response).to have_http_status(:ok)
  #     expect(JSON.parse(response.body)['id']).to eq(task.id)
  #   end

  #   it "denies access for an unauthorized user" do
  #     get "/api/v1/tasks/#{task.id}", headers: { 'Authorization' => "Bearer #{jwt_token(user)}" }
  #     expect(response).to have_http_status(:forbidden)
  #   end
  # end

  # describe "POST /api/v1/tasks" do
  #   let(:valid_task_params) do
  #     {
  #       task: {
  #         title: "New Task",
  #         description: "New task description",
  #         status: "pending",
  #         due_date: "2025-02-28",
  #         assigned_to_id: assigned_user.id
  #       }
  #     }
  #   end

  #   it "allows an admin to create a task" do
  #     post "/api/v1/tasks", params: valid_task_params.to_json, headers: headers
  #     expect(response).to have_http_status(:created)
  #     expect(JSON.parse(response.body)['title']).to eq("New Task")
  #   end

  #   it "denies a regular user from creating a task" do
  #     post "/api/v1/tasks", params: valid_task_params.to_json, headers: { 'Authorization' => "Bearer #{jwt_token(user)}" }
  #     expect(response).to have_http_status(:forbidden)
  #   end
  # end

  # describe "PUT /api/v1/tasks/:id" do
  #   let(:update_params) do
  #     { task: { title: "Updated Task Title" } }
  #   end

  #   it "allows an admin to update a task" do
  #     put "/api/v1/tasks/#{task.id}", params: update_params.to_json, headers: headers
  #     expect(response).to have_http_status(:ok)
  #     expect(JSON.parse(response.body)['title']).to eq("Updated Task Title")
  #   end

  #   it "allows assigned user to update their task" do
  #     put "/api/v1/tasks/#{task.id}", params: update_params.to_json, headers: { 'Authorization' => "Bearer #{jwt_token(assigned_user)}" }
  #     expect(response).to have_http_status(:ok)
  #     expect(JSON.parse(response.body)['title']).to eq("Updated Task Title")
  #   end

  #   it "denies a different user from updating the task" do
  #     put "/api/v1/tasks/#{task.id}", params: update_params.to_json, headers: { 'Authorization' => "Bearer #{jwt_token(user)}" }
  #     expect(response).to have_http_status(:forbidden)
  #   end
  # end

  # describe "DELETE /api/v1/tasks/:id" do
  #   it "allows an admin to delete a task" do
  #     delete "/api/v1/tasks/#{task.id}", headers: headers
  #     expect(response).to have_http_status(:no_content)
  #     expect(Task.exists?(task.id)).to be_falsey
  #   end

  #   it "denies a manager from deleting a task" do
  #     delete "/api/v1/tasks/#{task.id}", headers: { 'Authorization' => "Bearer #{jwt_token(manager)}" }
  #     expect(response).to have_http_status(:forbidden)
  #   end

  #   it "denies a regular user from deleting a task" do
  #     delete "/api/v1/tasks/#{task.id}", headers: { 'Authorization' => "Bearer #{jwt_token(user)}" }
  #     expect(response).to have_http_status(:forbidden)
  #   end
  # end
end
