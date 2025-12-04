FactoryBot.define do
    # salonモデルに対応するものとしてテストコード内でのダミーデータを生成する
    factory :salon do
    # 属性を設定
    salon_name { "テスト" }
    email { "salon@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
