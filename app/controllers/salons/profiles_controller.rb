class Salons::ProfilesController < ApplicationController
  before_action :authenticate_salon!
  before_action :set_salon, only: [ :show, :edit, :update ]

  def show
    # @salon は set_salon で設定済み
  end

  def edit
    # @salon は set_salon で設定済み
  end

  def update
    if @salon.update(salon_params)
      redirect_to salons_profile_path, notice: "プロフィールを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_salon
    # ログイン中のユーザー（Salon）を取得
    @salon = current_salon
  end

  def salon_params
    params.require(:salon).permit(:salon_name, :email)
  end
end
