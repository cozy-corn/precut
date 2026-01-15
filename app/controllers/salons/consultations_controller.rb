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
      @q = current_salon.consultations.ransack(params[:q])
      @consultations = @q.result(distinct: true)
                   .includes(:answers, :user)
                   .order(created_at: :desc)
    end

    def show
      # URLから渡されたIDでカルテを検索
      @consultation = Consultation.find_by!(uuid_url: params[:id])
      # セキュリティチェック
      # 取得したカルテが、現在ログイン中の美容室に紐づいているか確認
      unless @consultation.salon == current_salon
        redirect_to salons_consultations_path, alert: "アクセス権限がありません。"
      end
      # ※ N+1問題対策: 全回答データをここで一括で読み込む
      @answers = @consultation.answers.includes(:consultation).order(created_at: :asc)
    end

    def update
      @consultation = Consultation.find_by!(uuid_url: params[:id])

      # セキュリティチェック: 紐づきがない場合は処理しない
      unless @consultation.salon == current_salon
        return redirect_to salons_consultations_path, alert: "不正な操作が検出されました。"
      end

      # ステータスを 'archived' に更新
      if @consultation.update(status: "archived")
        # 成功したら詳細ページに戻り、成功メッセージを表示
        redirect_to salons_consultation_path(@consultation), notice: "カルテを「確認済」にしました。"
      else
        # 失敗したら詳細ページを再表示（エラーハンドリングは省略）
        redirect_to salons_consultation_path(@consultation), alert: "ステータスの更新に失敗しました。"
      end
    end

    # GET /salons/consultations/scan (QRコードスキャン用ページ)
    def scan
    end

    def autocomplete
      @users = User.where("full_name LIKE ?", "%#{params[:q]}%")
      render layout: false
    end
  end
end
