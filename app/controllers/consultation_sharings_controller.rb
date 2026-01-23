class ConsultationSharingsController < ApplicationController
  before_action :authenticate_user!
  def create
    # 1. 紐付けたいカルテを取得（他人のカルテの共有は不可）
    @consultation = current_user.consultations.find(params[:consultation_id])

    # 2. 既に共有データがあればそれを使う（重複作成を防ぐ）
    @sharing = @consultation.consultation_sharing ||
      @consultation.build_consultation_sharing(expires_at: 30.days.from_now)

    if @sharing.save
      # 3. 成功したら、Turboでビューを更新するためのレスポンスを返す
      #    （ボタンがQRコードに置き換わる）
      #    render 'consultations/replace_sharing_widget'は後で作成します
      render turbo_stream: turbo_stream.replace("sharing_widget", partial: "consultations/sharing_widget", locals: { consultation: @consultation })
    else
      # エラー時の処理
      flash[:alert] = "共有リンクの生成に失敗しました。"
      redirect_to consultation_path(@consultation)
    end
  rescue ActiveRecord::RecordNotFound
    # 権限がない、またはカルテが存在しない場合
    render plain: "対象のカルテが見つかりません。", status: :not_found
  end

  private

  # ボタンからの送信時に、consultation_idを受け取るためのストロングパラメータ
  def sharing_params
    params.permit(:consultation_id)
  end
end
