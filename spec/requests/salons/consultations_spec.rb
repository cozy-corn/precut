require 'rails_helper'

RSpec.describe "Salons::Consultations", type: :request do
  let(:salon) { create(:salon) }
  let(:user) { create(:user) }
  let(:consultation) { create(:consultation, user: user, salon: salon, status: :shared) }

  describe "GET /salons/consultations" do
    context "サロンがログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get salons_consultations_path
        expect(response).to redirect_to(new_salon_session_path)
      end
    end

    context "サロンがログインしている場合" do
      before { sign_in salon }

      it "正常にアクセスできること" do
        get salons_consultations_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /salons/consultations/:id" do
    context "サロンがログインしている場合" do
      before { sign_in salon }

      it "共有されたカルテに正常にアクセスできること" do
        get salons_consultation_path(consultation)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /salons/consultations/scan" do
    context "サロンがログインしている場合" do
      before { sign_in salon }

      it "QRコードスキャンページに正常にアクセスできること" do
        get scan_salons_consultations_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
