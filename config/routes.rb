Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  # ユーザーに関するルーティングを定義
  # 【resources 参考文献】https://api.rubyonrails.org/v8.0/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources
  resources :users

  # 部署に関するルーティングを定義
  resources :departments

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
