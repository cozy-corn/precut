class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[show edit update destroy]

    def index
      # 画面に表示する月の初日を取得（パラメータがなければ当日）
      @start_date = params.fetch(:start_date, Date.today).to_date
      # 基準日の月の初日と最終日を取得
      first_day = @start_date.beginning_of_month
      last_day = @start_date.end_of_month

      # ログインユーザーのイベントのうち、表示する月の期間内にあるイベントを抽出
      @events = current_user.events
                        .where(start_time: first_day.beginning_of_day..last_day.end_of_day)
                        .order(start_time: :asc)
    end

    def show; end

    def new
      @event = current_user.events.new(start_time: params[:date])
     end

    def create
      @event = current_user.events.new(event_params)
      if @event.save
        redirect_to user_path, notice: "予定を追加しました。"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @event.update(event_params)
        redirect_to user_path, notice: "予定を更新しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to user_path, notice: "予定を削除しました。"
    end

    private

    def set_event
      @event = current_user.events.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :start_time, :end_time)
    end
end
