class RoomsController < ApplicationController

  def new
    @room = Room.new
  end

  def create
    # room_params は 下端で定義しているprivateメソッド
    # Roomオブジェクトのuser_idカラム値は､ログイン中Userオブジェクトのidカラム値と一致させたい｡
    # だから､Reservationモデルを介した関連を利用しない方法で､後者を前者に渡し､下の記述で受け取っている｡
    @room = Room.new(room_params)
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

    # ルーム詳細ページに､ルーム予約フォームを入れたいので､そのフォームの作成に使う変数を設定
    @reservation = Reservation.new
  end

  def index
    # Room.where(user_id: current_user.id) で､
    # user_id値が､現在ログインしているユーザーのid値であるRoomレコードを取得(複数可)
    @rooms = Room.where(user_id: current_user.id)

    #rooms = current_user.rooms という関連を使った記述でも可
  end

  private
  # params を使用し､ルーム情報登録ページの送信ボタン押下､ルーム情報編集ページの編集ボタン押下によって送られたきたデータを取得｡
  # 尚､require,permitメソッドで､roomオブジェクトのname･introduction・price･address・image･user_id属性以外の取得データを弾く｡(Strong Parameters)
  def room_params
    params.require(:room).permit(:name, :introduction, :price, :address, :image, :user_id)
  end
end
