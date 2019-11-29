class ChangeUserIdTypeForLikes < ActiveRecord::Migration[5.2]
  def change
    change_column :likes, :user_id, :string
  end
end
