class Reservation < ApplicationRecord
  # Reservationモデル : Userモデル == 多 : 1 ｡FKはデフォルトのuser_id
  belongs_to :user
  # Reservationモデル : Roomモデル == 多 : 1 ｡FKはデフォルトのroom_id
  belongs_to :room
end
