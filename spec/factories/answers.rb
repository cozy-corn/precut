FactoryBot.define do
  factory :answer do
    association :consultation
    question { "テスト質問ですか？" }
    answer { "テスト回答です" }
  end
end
