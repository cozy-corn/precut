require 'rails_helper'

RSpec.describe "User Profile", type: :request do
  let(:user) { create(:user) }

  describe "GET /user (マイページ)" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get user_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "マイページにアクセスし、成功すること" do
        get user_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /user/edit (プロフィール編集)" do
    context "ログインしている場合" do
      before { sign_in user }

      it "編集ページにアクセスできること" do
        get edit_user_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH /user (プロフィール更新)" do
    context "ログインしている場合" do
      before { sign_in user }

      it "プロフィールを更新できること" do
        patch user_path, params: { user: { full_name: "新しい名前" } }
        expect(user.reload.full_name).to eq("新しい名前")
      end
    end
  end
end
