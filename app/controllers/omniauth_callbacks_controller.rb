class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def line
      basic_action
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

    # ダミーのemailアドレスを作成するメソッド
    def fake_email(uid, provider)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
