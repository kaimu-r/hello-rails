Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  # 一般ユーザーのルーティングを定義
  resources :users, only: [:index, :show] do
    # ユーザーの画像表示用のルーティング（管理画面でも使用）
    get "image", on: :member
  end

  namespace :admin do
    # ユーザーに関するルーティングを定義
    # 【resources 参考文献】https://api.rubyonrails.org/v8.0/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources
    resources :users

    # 部署に関するルーティングを定義
    resources :departments

    # スキルに関するルーティングを定義
    resources :skills

    # ログイン処理に関するルーティングを定義
    resource :login, only: [:new, :create, :destroy], controller: "sessions"
  end

  ## OAuth 専用ルーティング
  get "auth/google_oauth2/callback", to: "auth_callbacks#google_oauth2"

  # resourcesの代わりに個別でルーティングを定義する場合
  # get 'users', to: 'users#index'
  # post 'users/create', to: 'users#create'
  # get 'users/new', to: 'users#new'
  # get 'users/:id/edit', to: 'users#edit'
  # get 'users/:id', to: 'users#show'
  # patch 'users/:id', to: 'users#update'
  # put 'users/:id', to: 'users#update'
  # delete 'users/:id', to: 'users#destroy'
end
