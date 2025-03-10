FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 4) }
    description { Faker::Lorem.paragraph }
    due_date { Faker::Date.forward(days: 20) }
    assigned_to { association :user }
  end
end
