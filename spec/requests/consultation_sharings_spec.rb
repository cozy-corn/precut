require 'rails_helper'

RSpec.describe "ConsultationSharings", type: :request do
  let(:user) { create(:user) }
  let(:consultation) { create(:consultation, :completed, user: user) }

  describe "POST /consultation_sharings" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        post consultation_sharings_path, params: { consultation_id: consultation.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "共有リンクを作成できること" do
        expect {
          post consultation_sharings_path, params: { consultation_id: consultation.id }
        }.to change(ConsultationSharing, :count).by(1)
      end

      it "作成後にturbo_streamレスポンスが返ること" do
        post consultation_sharings_path, params: { consultation_id: consultation.id }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
