FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    due_date { "2025-02-26 15:15:32" }
    assigned_to { nil }
  end
end
