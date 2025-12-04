require 'rails_helper'

RSpec.describe Salon, type: :model do
  describe "バリデーションチェック" do
    context "有効な値の場合" do
      it "設定したすべてのバリデーションが機能しているか" do
        salon = build(:salon)
        expect(salon).to be_valid
        expect(salon.errors).to be_empty
      end
    end

    context "サロン名がない場合" do
      it "バリデーションに失敗すること" do
        salon = build(:salon, salon_name: nil)
        expect(salon).to be_invalid
        expect(salon.errors[:salon_name]).not_to be_empty
      end
    end

    context "メールアドレスがない場合" do
      it "バリデーションに失敗すること" do
        salon = build(:salon, email: nil)
        expect(salon).to be_invalid
        expect(salon.errors[:email]).not_to be_empty
      end
    end

    context "重複したメールアドレスの場合" do
      it "uniqueのバリデーションが機能して失敗すること" do
        salon = create(:salon)
        duplicate_salon = build(:salon, email: salon.email)
        expect(duplicate_salon).to be_invalid
        expect(duplicate_salon.errors[:email]).not_to be_empty
      end
    end

    context "パスワードのバリテーション" do
      it "パスワードが空欄の場合失敗すること" do
        salon = build(:salon, password: nil)
        expect(salon).to be_invalid
        expect(salon.errors[:password]).not_to be_empty
      end

      it 'パスワード確認が一致しない場合失敗すること' do
        salon = build(:salon, password: 'password', password_confirmation: 'different')
        expect(salon).to be_invalid
        expect(salon.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end

      it 'パスワードが6文字未満の場合失敗すること' do
        salon = build(:salon, password: '123', password_confirmation: '123')
        expect(salon).to be_invalid
        expect(salon.errors[:password]).to include("は6文字以上で入力してください")
      end
    end
  end
end
