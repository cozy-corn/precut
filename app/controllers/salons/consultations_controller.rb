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
        @total_consultations_count = current_salon.consultations.count
        @archived_consultations_count = current_salon.consultations.where(status: :archived).count
        # ログイン中の美容師に紐づくConsultationを全て取得し、作成日時の降順で並べる
        consultations = current_salon.consultations.order(created_at: :desc)
        @consultations = consultations.includes(:answers, :user)
      end

      def scan
      end
      # 詳細表示など他のアクションもここに追加します
    end
end
