class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    if user_signed_in?
      connect_line_account
    else
      basic_action
    end
  end

    private

    def basic_action
      # 認証情報を取得
      @omniauth = request.env["omniauth.auth"]
      # 認証情報が存在している場合
      if @omniauth.present?
        # 認証情報のproviderとuidを元に、ユーザーを発見もしくは初期化する。
        @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
        # 保存したユーザー情報のemailが空白なら
        if @profile.email.blank?
          # 三項演算子　認証情報の[info][email]が存在する場合その値を代入　そうでない場合認証情報の中身を使って、一意のダミーemailアドレスを作っている
          email = @omniauth["info"]["email"] ? @omniauth["info"]["email"] : "#{@omniauth["uid"]}-#{@omniauth["provider"]}@example.com"
          # current_userが存在するならそのまま代入、しないならその場で認証情報から新しいユーザーを作成している。
          @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email: email, full_name: @omniauth["info"]["name"], password: Devise.friendly_token[0, 20])
        end
        # set_values(@omniauth)はuserモデルで定義されたメソッド
        @profile.set_values(@omniauth)
        # ログイン動作を実施する
        sign_in(:user, @profile)
      end
      # ログイン後のflash messageとリダイレクト先を設定
      flash[:notice] = "ログインしました"
      # ここのリダイレクト先は後で自分のルーティングに応じて変更する
      redirect_to root_path
    end

    # LINEアカウントを現在のユーザーに紐付けるメソッド
    def connect_line_account
      @omniauth = request.env["omniauth.auth"]

      unless @omniauth && @omniauth["provider"].present? && @omniauth["uid"].present?
        flash[:alert] = "LINE連携に失敗しました"
        return redirect_to user_path
      end

      if User.exists?(provider: @omniauth["provider"], uid: @omniauth["uid"])
        flash[:alert] = "このLINEアカウントは既に登録されています"
      else
        current_user.update!(provider: @omniauth["provider"], uid: @omniauth["uid"])
        flash[:notice] = "LINEアカウントを紐付けました"
      end
      redirect_to user_path
    end
end
