require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "トップページに正常にアクセスできること" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
