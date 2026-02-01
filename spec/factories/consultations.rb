FactoryBot.define do
  factory :consultation do
    association :user
    status { "draft" }

    trait :completed do
      status { "completed" }
    end

    trait :shared do
      status { "shared" }
    end

    trait :with_answers do
      after(:create) do |consultation|
        create_list(:answer, 3, consultation: consultation)
      end
    end
  end
end
