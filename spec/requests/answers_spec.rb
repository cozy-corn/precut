require 'rails_helper'

RSpec.describe "Answers", type: :request do
  let(:user) { create(:user) }

  describe "GET /answers/new" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get new_answer_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "正常にアクセスできること" do
        get new_answer_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /answers" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        post answers_path, params: { answer: { question: "テスト", answer: "回答" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "回答を作成してリダイレクトされること" do
        # まずnewアクションでセッションにconsultation_idをセット
        get new_answer_path
        consultation = Consultation.last

        post answers_path, params: {
          answer: {
            question: "テスト質問",
            answer: "テスト回答",
            consultation_id: consultation.id
          }
        }
        expect(response).to redirect_to(new_answer_path)
      end
    end
  end
end
