class Room < ApplicationRecord
  # このモデルでAcitve Strageを使用する
  # 1つのroomに1つの画像を紐付けること､その画像をRoomモデルからimageと呼ぶことを指定
  has_one_attached :image

  # Roomモデル : Reservationモデル == 1 : 多｡FKはデフォルトのroom_id
  has_many :reservations
  # Reservationモデルを介したRoomモデル : Reservationモデルを介したUserモデル == 多 : 多
  has_many :users, through: :reservations
end
