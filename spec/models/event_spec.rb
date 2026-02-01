require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "バリデーションチェック" do
    context "有効な値の場合" do
      it "バリデーションを通過すること" do
        event = build(:event)
        expect(event).to be_valid
        expect(event.errors).to be_empty
      end
    end

    context "タイトルが空欄の場合" do
      it "バリデーションに失敗すること" do
        event = build(:event, title: nil)
        expect(event).to be_invalid
        expect(event.errors[:title]).not_to be_empty
      end
    end

    context "開始時間が空欄の場合" do
      it "バリデーションに失敗すること" do
        event = build(:event, start_time: nil)
        expect(event).to be_invalid
        expect(event.errors[:start_time]).not_to be_empty
      end
    end

    context "終了時間が空欄の場合" do
      it "バリデーションに失敗すること" do
        event = build(:event, end_time: nil)
        expect(event).to be_invalid
        expect(event.errors[:end_time]).not_to be_empty
      end
    end

    context "ユーザーが関連付けられていない場合" do
      it "バリデーションに失敗すること" do
        event = build(:event, user: nil)
        expect(event).to be_invalid
        expect(event.errors[:user]).not_to be_empty
      end
    end
  end

  describe "関連付け" do
    it "ユーザーに属すること" do
      event = create(:event)
      expect(event.user).to be_present
    end
  end
end
