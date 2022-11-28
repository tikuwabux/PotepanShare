class ReservationsController < ApplicationController
  def create
    # reservation_params は 下端で定義しているprivateメソッド
    # user_id, room_id ともにパラメーターとして受け取る方法で取得
    @reservation = Reservation.new(reservation_params)

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
