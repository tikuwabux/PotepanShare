class ReservationsController < ApplicationController
  def create
    #@reservation = current_user.rooms.reservations.new(reservation_params) => NoMethodError in ReservationsController#create
    # 上のような､RoomsControllerと同様の方法では､user_idのみ取得可｡room_idは取得不可｡
    # リレーション利用での値取得において､current_user(1).rooms(多).reservations(多) のような (多)が2つ重なる書き方は不可?

    # user_id, room_id ともにパラメーターとして受け取る方法に変更
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
  end

  private

  def reservation_params
    # Strong Parameters を設定
    params.require(:reservation).permit(:start_date, :end_date, :number_of_people, :user_id, :room_id)
  end
end
