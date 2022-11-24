class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # roomモデルと関連付ける(userモデル:roomモデル == 1:多).FKはデフォルトのuser_id
  has_many :rooms
end
