Rails.application.routes.draw do
  get 'home/index'
  get 'home/show'
  root to: 'home#index'

  # devise_for :users までは､rails g devise:controllers users コマンド実行時に自動生成
  # devse_forメソッドで､ログイン認証機能関連のルーティンを設定している
  # :users は､:divice内のログインユーザーの対象となっているモデル という意味｡
  devise_for :users, :controllers => {         #コントローラーについて
    :registrations => 'users/registrations',   #devise/registrations を users/registrations に変更
    :sessions => 'users/sessions'              #devise/sessions を users/sessions に変更
  }

  # devise_scopeでdeviceに新たなルーティンを追加(この方法で追加しないとエラーになる)
  # 2つめの､users/sessions#destroy への新たなパスを設定することは特に重要｡
  # デフォルトのパスである､delete destroy_user_session_path ではlink_toメソッドに入れた時､エラーになるから｡
  devise_scope :user do
    get "sign_up", :to => 'users/sessions#new'
    get 'sign_out', :to => 'users/sessions#destroy'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
