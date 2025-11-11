class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[edit update destroy]

    def index
      @events = current_user.events.order(start_time: :asc)
      # 画面に表示する月の初日を取得（パラメータがなければ当日）
      @start_date = params.fetch(:start_date, Date.today).to_date
    end

    def new
      @event = current_user.events.new(start_time: params[:date])
     end

    def create
      @event = current_user.events.new(event_params)
      if @event.save
        redirect_to events_path, notice: "予定を追加しました。"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @event.update(event_params)
        redirect_to events_path, notice: "予定を更新しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to events_path, notice: "予定を削除しました。"
    end

    private

    def set_event
      @event = current_user.events.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :start_time, :end_time)
    end
end
