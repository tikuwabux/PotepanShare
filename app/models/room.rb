class Room < ApplicationRecord
  # このモデルでAcitve Strageを使用する
  # 1つのroomに1つの画像を紐付けること､その画像をRoomモデルからimageと呼ぶことを指定
  has_one_attached :image

  # Roomモデル : Reservationモデル == 1 : 多｡FKはデフォルトのroom_id
  has_many :reservations
  # Reservationモデルを介したRoomモデル : Reservationモデルを介したUserモデル == 多 : 多
  has_many :users, through: :reservations

  # 以下のvalidationを追加
  validates :name, presence: true
  validates :introduction, presence: true, length: { maximum: 100 }
  validates :price, presence: true
  validates :address, presence: true
  validates :image, presence: true
end
