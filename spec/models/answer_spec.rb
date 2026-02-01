require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "バリデーションチェック" do
    context "有効な値の場合" do
      it "バリデーションを通過すること" do
        answer = build(:answer)
        expect(answer).to be_valid
        expect(answer.errors).to be_empty
      end
    end

    context "質問が空欄の場合" do
      it "バリデーションに失敗すること" do
        answer = build(:answer, question: nil)
        expect(answer).to be_invalid
        expect(answer.errors[:question]).not_to be_empty
      end
    end

    context "回答が空欄の場合" do
      it "バリデーションを通過すること（回答は任意）" do
        answer = build(:answer, answer: nil)
        expect(answer).to be_valid
      end
    end

    context "カウンセリングが関連付けられていない場合" do
      it "バリデーションに失敗すること" do
        answer = build(:answer, consultation: nil)
        expect(answer).to be_invalid
        expect(answer.errors[:consultation]).not_to be_empty
      end
    end
  end

  describe "関連付け" do
    it "カウンセリングに属すること" do
      answer = create(:answer)
      expect(answer.consultation).to be_present
    end
  end
end
