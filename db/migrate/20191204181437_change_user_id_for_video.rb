class ChangeUserIdForVideo < ActiveRecord::Migration[5.2]
  def change
    change_column :videos, :user_id, :string
  end
end
