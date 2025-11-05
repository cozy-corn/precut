# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user!
    # @user = User.find(params[:id]) のように、対象のユーザーをデータベースから取り出す小さなメソッド
    before_action :set_user, only: [ :show, :edit, :update ]
    before_action :authorize_user!, only: [ :edit, :update ]

    def show
      # @user は set_user でセット済み
    end

    def edit
      # 編集フォーム（@user = current_user）
    end

    def update
        # user_params は strong params で許可されたパラメータ
        # パスワードを含まない更新（full_name やメールのみ）
        if @user.update(user_params)
          redirect_to user_path(@user), notice: "プロフィールを更新しました。"
        else
          render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_user
      @user = current_user
    end

    def authorize_user!
      unless @user == current_user
        redirect_to root_path, alert: "許可されていない操作です。"
      end
    end

    def user_params
      # 許可するカラム
      params.require(:user).permit(:full_name, :email, :age_group)
    end
end
