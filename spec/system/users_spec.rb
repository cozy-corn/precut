require 'rails_helper'

RSpec.describe "ユーザー登録からカルテ作成まで", type: :system do
  it '新規登録 → ホームページ → カウンセリングを始める → カルテを作成  ができる' do
      # 新規登録
      visit new_user_registration_path
      within('form#new_user') do
        fill_in 'user_full_name', with: 'SystemTester'
        fill_in 'user_email', with: 'system@example.com'
        select '男性', from: 'user_gender'
        select '20代', from: 'user_age_group'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button '新規登録'
      end
      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'アカウント登録が完了しました。'

      click_link "カウンセリングを始める"
      expect(page).to have_current_path(new_answer_path)

      # カルテ作成フォームに回答して送信
      QUESTIONS = [
        "1週間の中でスタイリング剤もしくはアイロンは何日使用しますか？",
        "外出する時の朝は髪の毛は何をしますか？",
        "１年以内に縮毛矯正、パーマ、ブリーチはされていますか？履歴がある場合は施術した月と何をしたかを教えて下さい。",
        "ご希望のヘアスタイルを教えてください。",
        "なぜそのヘアスタイルにしたいと思いましたか？",
        "髪の悩みはありますか？",
        "希望の明るさや色味はありますか？希望のカラーがない、もしくはカラーをしない場合は「なし」とお答えください。",
        "参考とする画像があれば、当日までにご用意ください。よろしいですか？"
      ].freeze

      QUESTIONS.each_with_index do |question, index|
        expect(page).to have_content question
        # 回答内容を設定
        case index
        when 0
          answer = "週に3日"
        when 1
          answer = "軽くブローする"
        when 2
          answer = "ブリーチを半年前、縮毛矯正を2年前にしました。半分以上がブリーチ毛で、最近は傷みが気になっており、担当美容師さんに相談したい"
        else
          answer = "テストによる回答 #{index + 1}"
        end

        # 回答を入力して送信
        within('form[action="/answers"]') do
          fill_in 'answer_answer', with: answer
          click_button "送信"
        end

        if index < QUESTIONS.size - 1
          # まだ質問が残っている場合: 次の質問が表示されることを確認
          next_question = QUESTIONS[index + 1]

          # Turbo Driveの非同期遷移完了を待つ（現在の質問が消えるのを確認）
          expect(page).not_to have_content(question, wait: 3)

          # 次の質問が表示されることを確認
          expect(page).to have_content(next_question)

          # 送信した回答が表示されていることを確認
          expect(page).to have_content(answer)
        else
          # カルテページに遷移することを確認（URLは /consultations/UUID の形式）
          expect(page).to have_current_path(%r{/consultations/[0-9a-f-]+})
          expect(page).to have_content("カウンセリングが完了しました！")
        end
      end
  end
end
