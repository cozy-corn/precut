require 'rails_helper'

RSpec.describe Consultation, type: :model do
  describe "バリデーションチェック" do
    context "有効な値の場合" do
      it "バリデーションを通過すること" do
        consultation = build(:consultation)
        expect(consultation).to be_valid
        expect(consultation.errors).to be_empty
      end
    end

    context "ユーザーが関連付けられていない場合" do
      it "バリデーションに失敗すること" do
        consultation = build(:consultation, user: nil)
        expect(consultation).to be_invalid
        expect(consultation.errors[:user]).not_to be_empty
      end
    end
  end

  describe "ステータス" do
    it "デフォルトでdraftになること" do
      consultation = create(:consultation)
      expect(consultation.status).to eq("draft")
    end

    it "completedに変更できること" do
      consultation = create(:consultation)
      consultation.update!(status: :completed)
      expect(consultation.status).to eq("completed")
    end

    it "sharedに変更できること" do
      consultation = create(:consultation)
      consultation.update!(status: :shared)
      expect(consultation.status).to eq("shared")
    end
  end

  describe "関連付け" do
    it "回答を複数持てること" do
      consultation = create(:consultation, :with_answers)
      expect(consultation.answers.count).to eq(3)
    end

    it "削除時に関連する回答も削除されること" do
      consultation = create(:consultation, :with_answers)
      expect { consultation.destroy }.to change(Answer, :count).by(-3)
    end
  end

  describe "UUID" do
    it "作成時にuuid_urlが自動生成されること" do
      consultation = create(:consultation)
      expect(consultation.uuid_url).to be_present
    end

    it "to_paramがuuid_urlを返すこと" do
      consultation = create(:consultation)
      expect(consultation.to_param).to eq(consultation.uuid_url)
    end
  end
end
