require 'rails_helper'

RSpec.describe ConsultationSharing, type: :model do
  describe "バリデーションチェック" do
    context "有効な値の場合" do
      it "バリデーションを通過すること" do
        sharing = build(:consultation_sharing)
        expect(sharing).to be_valid
        expect(sharing.errors).to be_empty
      end
    end

    context "カウンセリングが関連付けられていない場合" do
      it "バリデーションに失敗すること" do
        sharing = build(:consultation_sharing, consultation: nil)
        expect(sharing).to be_invalid
        expect(sharing.errors[:consultation]).not_to be_empty
      end
    end

    context "同じカウンセリングに複数の共有を作成しようとした場合" do
      it "バリデーションに失敗すること" do
        consultation = create(:consultation)
        create(:consultation_sharing, consultation: consultation)
        duplicate_sharing = build(:consultation_sharing, consultation: consultation)
        expect(duplicate_sharing).to be_invalid
        expect(duplicate_sharing.errors[:consultation_id]).not_to be_empty
      end
    end
  end

  describe "トークン生成" do
    it "作成時にshared_tokenが自動生成されること" do
      sharing = create(:consultation_sharing)
      expect(sharing.shared_token).to be_present
    end

    it "トークンが一意であること" do
      sharing1 = create(:consultation_sharing)
      sharing2 = create(:consultation_sharing)
      expect(sharing1.shared_token).not_to eq(sharing2.shared_token)
    end

    it "トークンが20文字（16進数10バイト）であること" do
      sharing = create(:consultation_sharing)
      expect(sharing.shared_token.length).to eq(20)
    end
  end

  describe "関連付け" do
    it "カウンセリングに属すること" do
      sharing = create(:consultation_sharing)
      expect(sharing.consultation).to be_present
    end
  end
end
