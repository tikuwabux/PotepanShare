class RoomsController < ApplicationController

  def new
    @room = Room.new
  end

  def create
    # current_user(gem'device'を導入したモデル名) → deviseのヘルパーメソッド｡現在ログインしているユーザーのレコードを取得｡
    # .rooms → 紐付いたRoomオブジェクトらの一覧を得る
    # .new() → その一覧に､()内の値をもつRoomオブジェクトを追加
    # room_params → 下で定義しているprivateメソッド
    @room = current_user.rooms.new(room_params)

    # 生成したroomインスタンスをDBへ保存することが成功した時
    if @room.save
      flash[:notice] = "ルームの新規登録に成功しました"

      # room_path(id値) で 登録済みルーム詳細ページ(/rooms/id値)へ
      redirect_to room_path(@room.id)
    else
      flash[:notice] = "ルームの新規登録に失敗しました"
      # newアクションへ
      render "new"
    end
  end

  def show
    # Room.find(params[:id]) で､idがparams[:id]であるroomレコードを取得
    @room = Room.find(params[:id])
  end

  def index
    # Room.where(user_id: current_user.id) で､
    # user_id値が､現在ログインしているユーザーのid値であるRoomレコードを取得(複数可)
    @rooms = Room.where(user_id: current_user.id)

  end

  private
  # params を使用し､ルーム情報登録ページの送信ボタン押下､ルーム情報編集ページの編集ボタン押下によって送られたきたデータを取得｡
  # 尚､require,permitメソッドで､roomオブジェクトのname･introduction・price･address・･image属性以外の取得データを弾く｡(Strong Parameters)
  def room_params
    params.require(:room).permit(:name, :introduction, :price, :address, :image)
  end
end
