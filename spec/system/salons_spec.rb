require 'rails_helper'

RSpec.describe "サロンのログインからカルテ確認まで", type: :system do
  let!(:salon) { create(:salon) }
  let!(:user) { create(:user, full_name: 'テストユーザー') }
  let!(:consultation) { create(:consultation, :completed, user: user, salon: salon) }
  let!(:answer) { create(:answer, consultation: consultation, question: '髪の悩みは？', answer: '毛先のダメージ') }

  it 'サロンログインしてプロフィールページにアクセスできる' do
    sign_in salon

    visit salons_profile_path
    expect(page).to have_current_path(salons_profile_path)
  end

  it 'ログイン後にカルテ一覧にアクセスできる' do
    sign_in salon

    # カルテ一覧へ移動
    visit salons_consultations_path
    expect(page).to have_content('テストユーザー')
  end
end
