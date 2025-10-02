module QuestionList
    extend ActiveSupport::Concern

    QUESTIONS = [
      "ご希望のスタイルを教えてください。",
      "髪の長さはどのくらいにしますか？",
      "髪の悩みはありますか？",
      "希望の髪色はありますか？",
      "参考になる画像があれば、アップロードしてください。"
    ].freeze
end
