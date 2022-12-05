Rails.application.routes.draw do
  #Reservationモデルのルーティン
  #デフォルトのリソースルーティング + 予約確認ページ実装のため､新たに追加したnewアクション(confirm_newアクション)へのルーティング
  resources :reservations do
    post :confirm, action: :confirm_new, on: :new
    #=>  confirm_new_reservation  POST /reservations/new/confirm(.:format)   => reservations#confirm_new
  end

  # Roomモデルのルーティン
  # デフォルトのリソースルーティング + ルーム住所検索結果ページ実装のため､新たに追加したaddress_searchアクションへのルーティング
  resources :rooms do
    collection do
      get 'address_search'
      #=>  address_search_rooms  GET /rooms/address_search(.:format) => rooms#address_search
      # get 'freeword_name_search'
      #=> freeword_name_search_rooms    GET /rooms/freeword_name_search(.:format) => rooms#freeword_name_search
    end
  end

  # Homeモデルのルーティン
  get 'home/index'
  get 'home/show'
  root to: 'home#index'

  # Userモデルのルーティン

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
