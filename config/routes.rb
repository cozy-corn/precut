Rails.application.routes.draw do
  root "homes#index"
  devise_for :salons, controllers: {
    sessions: "salons/sessions", # サロン用にカスタマイズしたセッションコントローラーを指定
    passwords: "salons/passwords", # サロン用にカスタマイズしたパスワードコントローラーを指定
    registrations: "salons/registrations" # サロン用にカスタマイズした登録コントローラーを指定
  }
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  get "homes/index"
  resource :user, only: [ :show, :edit, :update ]
  resources :events

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")


  # Consultationの詳細（show）ページへのルート
  resources :consultations, only: [ :show ] do
    get "", on: :member, action: :show, constraints: { id: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }
  end
  resources :consultations, only: [ :index ]
  resources :consultations do
    member do
      get :recreate # /consultations/:id/recreate 再作成用ルート
      post :recreate # /consultations/:id/recreate 再作成保存用ルート
    end
  end
  resources :answers, only: [ :new, :create ]

  resources :consultation_sharings, only: [ :create ]
  # 3. トークンを使ったアクセス用（例: /shared/abc12345）
  get "shared/:token", to: "consultations#show_shared", as: :shared_consultation
  # サロン側のルーティング
  namespace :salons do
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
