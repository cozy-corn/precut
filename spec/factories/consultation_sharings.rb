FactoryBot.define do
  factory :consultation_sharing do
    association :consultation
    expires_at { 30.days.from_now }
    # shared_token は before_validation で自動生成される
  end
end
