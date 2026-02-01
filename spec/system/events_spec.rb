require 'rails_helper'

RSpec.describe "イベント管理", type: :system do
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  it 'マイページでカレンダーが表示される' do
    visit user_path
    expect(page).to have_content('予約日')
    expect(page).to have_content('予約日を入力する')
  end

  it 'イベントを作成できる' do
    visit new_event_path

    fill_in 'event_title', with: '美容院予約'

    # 日時フィールドの入力（JavaScriptを使用）
    tomorrow = 1.day.from_now
    start_time = tomorrow.strftime('%Y-%m-%dT%H:%M')
    end_time = (tomorrow + 1.hour).strftime('%Y-%m-%dT%H:%M')

    page.execute_script("document.getElementById('event_start_time').value = '#{start_time}'")
    page.execute_script("document.getElementById('event_end_time').value = '#{end_time}'")

    click_button '登録'

    # 作成後にマイページにリダイレクトされ、予定が表示されること
    expect(page).to have_content('予定を追加しました')
  end
end
