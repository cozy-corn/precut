require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event, user: user) }

  describe "GET /events/new" do
    context "ログインしている場合" do
      before { sign_in user }

      it "正常にアクセスできること" do
        get new_event_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /events/:id" do
    context "ログインしている場合" do
      before { sign_in user }

      it "正常にアクセスできること" do
        get event_path(event)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /events" do
    context "ログインしている場合" do
      before { sign_in user }

      it "イベントを作成できること" do
        expect {
          post events_path, params: {
            event: {
              title: "新しい予約",
              start_time: 1.day.from_now,
              end_time: 1.day.from_now + 1.hour
            }
          }
        }.to change(Event, :count).by(1)
      end
    end
  end

  describe "DELETE /events/:id" do
    context "ログインしている場合" do
      before { sign_in user }

      it "イベントを削除できること" do
        event_to_delete = create(:event, user: user)
        expect {
          delete event_path(event_to_delete)
        }.to change(Event, :count).by(-1)
      end
    end
  end
end
