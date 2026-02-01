require 'rails_helper'

RSpec.describe "Consultations", type: :request do
  let(:user) { create(:user) }
  let(:consultation) { create(:consultation, user: user) }

  describe "GET /consultations" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get consultations_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "正常にアクセスできること" do
        get consultations_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /consultations/:id" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get consultation_path(consultation)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "自分のカルテに正常にアクセスできること" do
        get consultation_path(consultation)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /shared/:token" do
    let!(:sharing) do
      create(:consultation_sharing, consultation: consultation, expires_at: 30.days.from_now)
    end

    it "共有トークンで正常にアクセスできること" do
      get shared_consultation_path(sharing.shared_token)
      expect(response).to have_http_status(:success)
    end

    it "無効なトークンの場合ルートにリダイレクトされること" do
      get shared_consultation_path("invalid_token")
      expect(response).to redirect_to(root_path)
    end

    it "期限切れの場合ルートにリダイレクトされること" do
      sharing.update!(expires_at: 1.day.ago)
      get shared_consultation_path(sharing.shared_token)
      expect(response).to redirect_to(root_path)
    end
  end
end
