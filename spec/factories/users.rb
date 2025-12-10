# ユーザーファクトリ（データ生成の設計図）を定義
FactoryBot.define do
  # Userモデルに対応するものとしてテストコード内でのダミーデータを生成する
  factory :user do
    # name 属性: "テスト" という値を設定
    full_name { "テスト" }
    email { |n| "test#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
