class RoomsController < ApplicationController
  def index
  end

  def new
    @room = Room.new
  end

  def create
    # params を使用し､ルーム情報登録ページの送信ボタン押下によって送られたきたデータを取得｡
    # 尚､require,permitメソッドで､roomオブジェクトのname･introduction・price･address・image属性以外の取得データを弾く｡(Strong Parameters)
    # Room.new(取得データ)で､取得データをもつroomインスタンスを生成
    @room = Room.new(params.require(:room).permit(:name, :introduction, :price, :address, :image))

    # 生成したroomインスタンスをDBへ保存することが成功した時
    if @room.save
      flash[:notice] = "ルームの新規登録に成功しました"
      # 登録済みルーム詳細ページへ
      redirect_to room_path
    else
      flash[:notice] = "ルームの新規登録に失敗しました"
      # newアクションへ
      render "new"
    end
  end
end
