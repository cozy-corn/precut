Rails.application.routes.draw do
  # ルートとdeviseの設定
  root "homes#index"
  devise_for :salons, controllers: {
    sessions: "salons/sessions", # サロン用にカスタマイズしたセッションコントローラーを指定
    passwords: "salons/passwords", # サロン用にカスタマイズしたパスワードコントローラーを指定
    registrations: "salons/registrations" # サロン用にカスタマイズした登録コントローラーを指定
  }
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }

  # ユーザープロフィールとイベント用のルーティング
  resource :user, only: [ :show, :edit, :update ]
  resources :events

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  # ヘルスチェック用ルート
  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Consultationの詳細（show）ページへのルート
  resources :consultations, only: [ :index, :show ] do
    # 1. UUIDを使ったアクセス用（例: /consultations/550e8400-e29b-41d4-a716-446655440000）
    get "", on: :member, action: :show, constraints: { id: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }

    member do
      get :recreate # /consultations/:id/recreate 再作成用ルート
      post :recreate # /consultations/:id/recreate 再作成保存用ルート
    end
  end

  # 2. 新規相談フォームと作成用ルート
  resources :answers, only: [ :new, :create ]
  resources :consultation_sharings, only: [ :create ]
  # 3. トークンを使ったアクセス用（例: /shared/abc12345）
  get "shared/:token", to: "consultations#show_shared", as: :shared_consultation

  # サロン側のルーティング
  namespace :salons do
    resource :profile, only: [ :show, :edit, :update ]

    resources :consultations, only: [ :index, :show, :update ] do
      get :scan, on: :collection # /salons/consultations/scan　QRコード読み取りページ
      get :autocomplete, on: :collection # /salons/consultations/autocomplete ユーザー検索のオートコンプリート用
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resource :static, only: [] do
    collection do
    get "terms_of_service"
    get "privacy_policy"
    end
  end
end
