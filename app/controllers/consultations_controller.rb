class ConsultationsController < ApplicationController
    def show
        # URLから :id を受け取り、現在のユーザーに紐づくConsultationを取得
        # 例: /consultations/1 にアクセスすると、params[:id] は 1 になる
        @consultation = current_user.consultations.find(params[:id])
    
        # このConsultationに紐づく全ての質問と回答のセットを取得
        # 作成日時を昇順（ASC）に並べて、会話の流れを再現する
        @answers = @consultation.answers.order(created_at: :asc)
        # 取得した@consultationと@answersをビュー（HTML）に渡す
    end
end
