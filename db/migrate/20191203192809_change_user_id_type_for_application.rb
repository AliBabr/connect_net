class ChangeUserIdTypeForApplication < ActiveRecord::Migration[5.2]
  def change
    change_column :applications, :user_id, :string
  end
end
