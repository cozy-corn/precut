class SendLineMessageJob < ApplicationJob
  queue_as :default

  def perform
    # find_each を使用することで、大量ユーザーでもメモリを圧迫せずに処理できます。
    User.find_each do |user|
      next unless user.uid.present?                   # LINE UIDがあるか確認

      # 1. ユーザーのイベント情報を取得し、リマインダーメッセージを生成
      reminder_message = generate_reminder_message(user)

      # 2. メッセージが空でなければ送信
      if reminder_message.present?
          LineNotifyService.push_text_message(user.uid, reminder_message)
      end
    end
  end

  private

  # ユーザーに紐づく、リマインド対象のイベントを検索し、メッセージを構築する
  def generate_reminder_message(user)
    # --- 検索ロジック ---
    # 翌日（今日の日付の24時間後まで）に開始するイベントを検索する例
    tomorrow_start = Time.zone.now.beginning_of_day + 1.day
    tomorrow_end   = tomorrow_start.end_of_day

    # User.events の関連付けを使って検索
    upcoming_events = user.events.where(
      start_time: tomorrow_start..tomorrow_end
    ).order(:start_time)
    # --- メッセージ ---
    return unless upcoming_events.any? # イベントがない場合はnilを返す

    message = "【明日予約のお知らせ】\n"
    message << "#{user.full_name}さん、以下の予約があります！\n\n"

    upcoming_events.each do |event|
      # 開始時間を「HH:MM」形式に
      start_time_str = event.start_time.strftime("%H:%M")

      message << "・#{start_time_str} 開始: #{event.title}\n"
    end
      message << "ご来店をお待ちしております！"
      message
  end
end
