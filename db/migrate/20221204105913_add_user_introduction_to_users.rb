class AddUserIntroductionToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :user_introduction, :text
  end
end
