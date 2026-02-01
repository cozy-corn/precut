require 'rails_helper'

RSpec.describe "Salons::Profiles", type: :request do
  let(:salon) { create(:salon) }

  describe "GET /salons/profile" do
    context "サロンがログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get salons_profile_path
        expect(response).to redirect_to(new_salon_session_path)
      end
    end

    context "サロンがログインしている場合" do
      before { sign_in salon }

      it "正常にアクセスできること" do
        get salons_profile_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /salons/profile/edit" do
    context "サロンがログインしている場合" do
      before { sign_in salon }

      it "正常にアクセスできること" do
        get edit_salons_profile_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
