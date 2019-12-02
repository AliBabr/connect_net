class ChangeUserIdForGoings < ActiveRecord::Migration[5.2]
  def change
    change_column :goings, :user_id, :string
  end
end
