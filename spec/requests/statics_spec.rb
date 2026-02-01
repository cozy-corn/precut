require 'rails_helper'

RSpec.describe "Statics", type: :request do
  describe "GET /static/terms_of_service" do
    it "利用規約ページに正常にアクセスできること" do
      get terms_of_service_static_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /static/privacy_policy" do
    it "プライバシーポリシーページに正常にアクセスできること" do
      get privacy_policy_static_path
      expect(response).to have_http_status(:success)
    end
  end
end
