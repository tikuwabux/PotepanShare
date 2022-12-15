class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Userモデル : Reservationモデル == 1 : 多｡FKはデフォルトのuser_id
  has_many :reservations
  # Reservationモデルを介したUserモデル : Reservationモデルを介したRoomモデル == 多 : 多
  has_many :rooms, through: :reservations

  # gem 'device'に追加したname属性と､user_introduction属性のvalidationを設定
  validates :name, presence: true
  validates :user_introduction, length: { maximum: 100 }

  # このモデルでAcitve Strageを使用する
  # 1つのuserオブジェクトに1つの画像を紐付けること､その画像をUserモデルからuser_imageと呼ぶことを指定｡
  # 以降､user_image は､usersテーブルのカラム名のように扱える｡
  has_one_attached :user_image
end
