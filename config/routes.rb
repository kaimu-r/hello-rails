Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  # ユーザーに関するルーティングを定義
  # 【resources 参考文献】https://api.rubyonrails.org/v8.0/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources
  resources :users
end
