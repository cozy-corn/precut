class LineNotifyService
    # 環境変数からトークンを取得。
    LINE_CHANNEL_TOKEN = ENV["LINE_CHANNEL_TOKEN"]

    def self.push_text_message(to_uid, message_text)
      # 1. 送信するメッセージオブジェクトを作成
      messages = [
        Line::Bot::V2::MessagingApi::TextMessage.new(text: message_text)
      ]

      # 2. プッシュリクエストオブジェクトを作成
      push_request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
        to: to_uid,
        messages: messages
      )

      # 3. メッセージ送信を実行 (SDKの機能を利用)
      # SDKが裏側で、URIのパース、HTTPヘッダー、JSONのダンプ、通信処理をすべて実行します。
      response, status_code, _ = client.push_message_with_http_info(
        push_message_request: push_request
      )

      # 4. 実行結果をチェックし、ログを出力
      self.handle_response(status_code, response)

    rescue StandardError => e
      # 予期せぬ通信エラーなどをキャッチし、ログに出力
      Rails.logger.error "LINE API Error (Client): #{e.message}"
      false
    end

    # レスポンスのステータスコードに基づいてログを出力するヘルパーメソッド
    private_class_method def self.handle_response(status_code, response)
      case status_code
      when 200
        Rails.logger.info "LINE通知 送信成功"
        return true
      when 401
        Rails.logger.error "LINE通知 送信失敗: 認証エラー (401)"
      when 404
        Rails.logger.error "LINE通知 送信失敗: リソースが見つかりません (404)"
      else
        # その他のエラーコード
        Rails.logger.error "LINE通知 送信失敗: #{status_code}"
        # エラーの詳細（ボディ）をログに出力
        Rails.logger.error "レスポンスボディ: #{response}"
      end
      false
    end

    # LINEクライアントオブジェクトの初期化と取得
    private_class_method def self.client
      # @client にクライアントオブジェクトを保存し、再利用
      @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
        channel_access_token: LINE_CHANNEL_TOKEN
      )
    end
end
