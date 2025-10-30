module Salons
    # 美容師（サロン）側の顧客カルテ一覧と管理を行うコントローラー
    class ConsultationsController < ApplicationController
      # ログイン中のSalon（美容師）のみアクセスを許可する
      # Deviseによって自動生成されるヘルパーメソッド
      before_action :authenticate_salon!
      # layouts/salon_application.html.erb を使用するよう指定
      layout "salon_application"
      # GET /salons/consultations (美容師モードのホーム/カルテ一覧)
      def index
      end

      def scan
      end
      # 詳細表示など他のアクションもここに追加します
    end
end
