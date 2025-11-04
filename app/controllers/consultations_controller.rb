class ConsultationsController < ApplicationController
  before_action :authenticate_user!, only: [ :show, :index ] # 通常のshowは認証必須

  # トークンを使って共有カルテを表示するアクション
  # 共有リンクからのアクセスなので、認証は不要（セキュリティはトークンに依存）
  def show_shared
    # 1. トークンをDBで検索
    @sharing = ConsultationSharing.find_by(shared_token: params[:token])

    # 2. 共有レコードが存在しない、または有効期限切れの場合
    if @sharing.nil? || @sharing.expires_at.past?
      # エラーページまたはメッセージを表示
      flash[:alert] = "この共有リンクは無効または期限切れです。"
      return redirect_to root_path
    end

    # 3. 共有レコードからカルテ本体を取得
    @consultation = @sharing.consultation

    # 4. カルテに紐づく回答を取得
    @answers = @consultation.answers.order(created_at: :asc)

    # 5. ログインしているサロンがいる場合、初回アクセス時のみ紐づける
    if current_salon && @consultation.salon_id.nil?
      @consultation.update!(salon_id: current_salon.id)
    end

    # 6. 通常のカルテ詳細ビューを再利用して表示
    render "consultations/show"
  end

  def show
    # URLから :id を受け取り、現在のユーザーに紐づくConsultationを取得
    # 例: /consultations/1 にアクセスすると、params[:id] は 1 になる
    @consultation = current_user.consultations.find_by!(uuid_url: params[:id])

    # このConsultationに紐づく全ての質問と回答のセットを取得
    # 作成日時を昇順（ASC）に並べて、会話の流れを再現する
    @answers = @consultation.answers.order(created_at: :asc)
    # 取得した@consultationと@answersをビュー（HTML）に渡す
  end

  def index
    @consultations = current_user.consultations.order(created_at: :desc)
  end

  def recreate
    @original = current_user.consultations.find_by!(uuid_url: params[:id])

    if !request.post?
      # 元カルテのanswersを取得してフォームに表示
      @original_answers = @original.answers.order(:created_at)
      render :recreate
      return
    end

    # POST処理
    answers_params = params.permit(answers: [ :question, :answer ])[:answers] || []

    ActiveRecord::Base.transaction do
      @consultation = current_user.consultations.create!(status: :draft)

      answers_params.each do |a|
        @consultation.answers.create!(
          question: a[:question],
          answer: a[:answer]
        )
      end
    end
    redirect_to consultation_path(@consultation), notice: "新しいカルテを作成しました。"
  end
end
