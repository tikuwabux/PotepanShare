class Reservation < ApplicationRecord
  # Reservationモデル : Userモデル == 多 : 1 ｡FKはデフォルトのuser_id
  belongs_to :user
  # Reservationモデル : Roomモデル == 多 : 1 ｡FKはデフォルトのroom_id
  belongs_to :room

  validates :start_date, presence: true
  # 予約開始日に､現在よりも前の日付を登録することを禁止
  validate :validate_start_date

  validates :end_date, presence: true
  # 予約終了日に､開始日より前に日付を登録することを禁止
  validate :validate_end_date

  validates :number_of_people, presence: true
  validates :user_id, presence: true
  validates :room_id, presence: true

  private

  # 予約開始日に､現在より前の日付を登録することを禁止するprivateメソッド
  def validate_start_date
    if self.start_date.present? #この条件つけないと､予約開始日未入力の時 NoMethodError# #undefined method `<' for nil:NilClass が発生する
      if self.start_date < Date.current
        errors.add(:start_date, "に現在より前の日付は登録できません")
      end
    end
  end

  # 予約終了日に､予約開始日より前の日付を登録することを禁止するprivateメソッド
  def validate_end_date
    if self.end_date.present? && self.start_date.present? #この条件つけないと､予約開始日や終了日が未入力の時 NoMethodError# #undefined method `<' for nil:NilClass が発生する
      if self.end_date < self.start_date
        errors.add(:end_date, "に開始日より前の日付は登録できません")
      end
    end
  end
end
