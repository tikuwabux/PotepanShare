class ReservationsController < ApplicationController

  # 予約確認ページ(予約フォームがあるルーム詳細ページと､予約詳細ページの間に挿入)に対応
  def confirm_new
    # createアクション時と同一のreservationインスタンスを生成(記述も同一)
    @reservation = Reservation.new(reservation_params)
    # validateエラーがあった場合 → ルーム詳細ビューファイルへ
    redirect_to room_path(reservation_params[:room_id]) if @reservation.invalid?
  end

  def create
    # reservation_params は 下端で定義しているprivateメソッド
    # user_id, room_id ともにパラメーターとして受け取る方法で取得
    @reservation = Reservation.new(reservation_params)

    # 予約確認ページの｢ルーム詳細に戻る｣ボタン押下で､このアクションに遷移してきた場合のみ
    if params[:back].present?
      #renderをredirectに変更.room_id値は非表示フォームから送信されてきている
      redirect_to room_path(reservation_params[:room_id])
      return  # 処理を終了する(@reservation.save前に終了させることで､DBへの保存を防ぐ)
    end

    if @reservation.save
      flash[:notice] = "#{@reservation.room.name}ルームの予約に成功しました"
      redirect_to reservation_path(@reservation.id)

    else
      flash[:notice] = "#{@reservation.room.name}ルームの予約に失敗しました"
      redirect_to room_path(@reservation.room.id)
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def index
    # リレーションを利用
    @rooms = current_user.rooms
  end

  private

  def reservation_params
    # Strong Parameters を設定
    params.require(:reservation).permit(:start_date, :end_date, :number_of_people, :user_id, :room_id)
  end
end
