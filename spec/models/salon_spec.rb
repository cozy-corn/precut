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

    context "メールアドレスがない場合" do
      it "バリデーションに失敗すること" do
        salon = build(:salon, email: nil)
        expect(salon).not_to be_valid
        expect(salon.errors[:email]).not_to be_empty
      end
    end

    context "サロン名がない場合" do
      it "バリデーションに失敗すること" do
        salon = build(:salon, salon_name: nil)
        expect(salon).not_to be_valid
        expect(salon.errors[:salon_name]).not_to be_empty
      end
    end
  
end
