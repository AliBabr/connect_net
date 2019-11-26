class ChangeUserIdTypeForRole < ActiveRecord::Migration[5.2]
  def change
    change_column :roles, :user_id, :string
  end
end
