class Reservation < ApplicationRecord
  # Userモデルと関連付ける(Reservationモデル:Userモデル == 1:多 )｡FKはデフォルトのuser_id
  belongs_to :user
  # Roomモデルと関連付ける(Reservationモデル:Roomモデル == 1:多 )｡FKはデフォルトのroom_id
  belongs_to :ro
end
