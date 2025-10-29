class AnswersController < ApplicationController
  before_action :authenticate_user!
    # Step 1: 質問リストを読み込む
    include QuestionList
    QUESTIONS = QuestionList::QUESTIONS
  def new
    # ① 継続中のカウンセリングセッションを取得または開始
    # セッションにIDがあれば既存のものを使い、なければ新しく作成する
    if session[:consultation_id].present?
      @consultation = current_user.consultations.find_by(id: session[:consultation_id])
      @consultation ||= current_user.consultations.create!
    else
      #  データベースに新しいconsultationレコードを作成
      @consultation = current_user.consultations.create!
      # カルテIDをセッションに保存している
      session[:consultation_id] = @consultation.id
    end

    # ② データベースに保存された回答の数を数える(@consultationに紐づいているanswersレコード（これまでの回答）の数を数えてanswered_countという変数に入れている)
    answered_count = @consultation.answers.count

    # ③ 回答数に基づいて、表示する質問を決定
    @current_question = QUESTIONS[answered_count]

    # ④ すべての質問が終わったかチェック
    if @current_question.nil?
      # ★★★ ここにステータス変更処理を追加 ★★★
      # @consultation の status を completed に変更し、DBに保存する
      @consultation.update!(status: :completed)
      # 全ての質問が完了したら、セッションを終了して完了ページにリダイレクト
      session.delete(:consultation_id)
      redirect_to consultation_path(@consultation), notice: "カウンセリングが完了しました！"
    else
      # 質問が残っていれば、回答フォームを準備
      @answer = @consultation.answers.new
      # 過去のやり取りをすべて取得（UI表示用）
      @answers = @consultation.answers.order(:created_at)
    end
  end


  def create
    # フォームから consultation_id を取得
    @consultation = current_user.consultations.find(params[:answer][:consultation_id])

    # フォームから送られた回答を Answer モデルに紐づける
    @answer = @consultation.answers.new(answer_params)

    # 回答をanswersテーブルのデータベースに保存
    if @answer.save
      # 保存が成功したら、次の質問のためにnewアクションへリダイレクト
      redirect_to new_answer_path
    else
      # 保存に失敗したら、同じ画面を再表示（エラーメッセージ付き）
      # ここでは`@answers`や`@current_question`も再設定が必要
      answered_count = @consultation.answers.count
      @current_question = QUESTIONS[answered_count] # 現在の質問を再設定
      @answers = @consultation.answers.order(:created_at)
      render :new, status: :unprocessable_entity
    end
   end

    private

      def answer_params
        # フォームから送られるパラメータを許可する
        params.require(:answer).permit(:question, :answer, :consultation_id)
      end
end
