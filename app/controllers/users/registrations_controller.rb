# frozen_string_literal: true

# サインアップ(パスワード登録),パスワード編集､等のコントローラー
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /users/sign_up
  def new
    super

    # 本当にこのコントローラーが叩かれているのか確認するために追加
    puts '========================='
    puts 'GET /users/sign_up'
    puts '========================='
  end

  # POST /users
  def create
    super
  end

  # GET /users/edit
  def edit
    super

    puts '========================='
    puts 'GET /users/edit'
    puts '========================='
  end

  # PUT /users
  def update
    super
  end

  # DELETE /users
  def destroy
    super
  end

  # GET /users/cancel
  # 通常はサインイン後に
  # 期限切れになるセッションデータを強制的に今すぐ期限切れにします。
  # これは、ユーザーがすべての OAuth セッションデータを削除して、
  # 途中で oauth サインイン/アップをキャンセルしたい場合に便利です。
  def cancel
    super
  end

  protected
  # サインアップ時用のメソッド
  # 許可するための追加のパラメータがある場合は、sanitizer に追加してください
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute, :name]) # :name を追加した
  end

  # アカウント編集時用のメソッド
  # 許可するための追加のパラメータがある場合は、sanitizer に追加してください
  # => :name(ユーザー名)を追加した
  # => :user_image(ユーザー画像)を追加した
  # => :user_introduction(ユーザー自己紹介)を追加した
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute, :name, :user_image, :user_introduction])
  end

  # サインアップ後に使用する path
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # アクティブでないアカウントのサインアップ後に使用する path
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  # ユーザー編集後のリダイレクト先を指定するメソッド(deviseで実装済みのメソッドだが､自動生成されなかったため自分で作成)
  def after_update_path_for(resource)
    # リダイレクト先を「ユーザー編集ページ」に指定
    # ログイン中のユーザーは常に1人であり､編集するユーザーレコードのid値も固定されているので､パスの引数にid値を渡す必要なし｡
    edit_user_registration_path()
  end
end
