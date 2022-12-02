class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Userモデル : Reservationモデル == 1 : 多｡FKはデフォルトのuser_id
  has_many :reservations
  # Reservationモデルを介したUserモデル : Reservationモデルを介したRoomモデル == 多 : 多
  has_many :rooms, through: :reservations

  # gem 'device'に追加したname属性のvalidationを設定
  validates :name, presence: true
  
end
