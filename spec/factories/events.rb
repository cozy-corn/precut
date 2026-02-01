FactoryBot.define do
  factory :event do
    association :user
    title { "美容院予約" }
    start_time { 1.day.from_now.beginning_of_hour }
    end_time { 1.day.from_now.beginning_of_hour + 1.hour }
  end
end
