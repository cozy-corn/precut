Rails.application.routes.draw do
  root "homes#index"
  devise_for :salons, controllers: {
    sessions: "salons/sessions", # サロン用にカスタマイズしたセッションコントローラーを指定
    passwords: "salons/passwords", # サロン用にカスタマイズしたパスワードコントローラーを指定
    registrations: "salons/registrations" # サロン用にカスタマイズした登録コントローラーを指定
  }
  devise_for :users
  get "homes/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")


  # Consultationの詳細（show）ページへのルートを追加
  resources :consultations, only: [ :show ] do
    get "", on: :member, action: :show, constraints: { id: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }
  end

  resources :answers, only: [ :new, :create ]

  resources :consultation_sharings, only: [ :create ]
  # 3. トークンを使ったアクセス用（例: /shared/abc12345）
  get "shared/:token", to: "consultations#show_shared", as: :shared_consultation
  # サロン側のルーティング
  namespace :salons do
    resources :consultations, only: [ :index, :show ] do
    end
  end
end
