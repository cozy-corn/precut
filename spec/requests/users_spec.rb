require 'rails_helper'

RSpec.describe "User Profile", type: :request do
  let(:user) { create(:user) } 

  describe "GET /user (マイページ)" do
    context "ログインしている場合" do
      it "マイページにアクセスし、成功すること" do
        sign_in user 
        
        get user_path 
        
        expect(response).to have_http_status(200)
      end
    end
  end
end