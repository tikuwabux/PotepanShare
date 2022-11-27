class Room < ApplicationRecord
  # userモデルに関連付ける(userモデル:roomモデル == 1:多)｡FKはデフォルトのuser_id
  belongs_to :user

  # このモデルでAcitve Strageを使用する
  # 1つのroomに1つの画像を紐付けること､その画像をRoomモデルからimageと呼ぶことを指定
  has_one_attached :image

  # Reservationモデルと関連付ける(Reservationモデル:Roomモデル == 1:多 )｡FKはデフォルトのroom_id
  has_many :reservations
end
