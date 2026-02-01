require 'rails_helper'

RSpec.describe "カルテ共有", type: :system do
  let!(:user) { create(:user) }
  let!(:consultation) { create(:consultation, :completed, user: user) }
  let!(:answer) { create(:answer, consultation: consultation, question: '髪の悩みは？', answer: 'パサつきが気になる') }

  it '共有リンクでカルテを閲覧できる' do
    # 共有リンクを作成（有効期限を設定）
    sharing = ConsultationSharing.create!(consultation: consultation, expires_at: 30.days.from_now)

    # 共有リンクでアクセス（ログイン不要）
    visit shared_consultation_path(sharing.shared_token)

    # カルテの内容が表示されること
    expect(page).to have_content('髪の悩みは？')
    expect(page).to have_content('パサつきが気になる')
  end

  it 'ログインユーザーが自分のカルテを閲覧できる' do
    sign_in user

    # カルテ詳細ページへ
    visit consultation_path(consultation)

    # カルテの内容が表示されること
    expect(page).to have_content('髪の悩みは？')
  end
end
