require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    context "有効な値の場合" do
      it "バリテーションを通過すること" do
        user = build(:user)
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
    end

    context "メールアドレスが空欄の場合" do
      it "バリデーションに失敗すること" do
        user = build(:user, email: nil)
        expect(user).to be_invalid
        expect(user.errors[:email]).not_to be_empty
      end
    end

    context "名前が空欄の場合" do
      it "バリデーションに失敗すること" do
        user = build(:user, full_name: nil)
        expect(user).to be_invalid
        expect(user.errors[:full_name]).not_to be_empty
      end
    end

    context "パスワードのバリテーション" do
      it "パスワードが空欄の場合失敗すること" do
        user = build(:user, password: nil)
        expect(user).to be_invalid
        expect(user.errors[:password]).not_to be_empty
      end

      it 'パスワード確認が一致しない場合失敗すること' do
        user = build(:user, password: 'password', password_confirmation: 'different')
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end

      it 'パスワードが6文字未満の場合失敗すること' do
        user = build(:user, password: '123', password_confirmation: '123')
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
    end

    context "名前が短すぎる場合" do
      it "バリデーションに失敗すること" do
        user = build(:user, full_name: "a")
        expect(user).not_to be_valid
        expect(user.errors[:full_name]).not_to be_empty
      end
    end

    context "重複したメールアドレスの場合" do
      it "uniqueのバリデーションが機能して失敗すること" do
        user = create(:user)
        duplicate_user = build(:user, email: user.email)
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).not_to be_empty
      end
    end
  end
end
