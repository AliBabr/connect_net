class ChangeUserIdTypeForEvents < ActiveRecord::Migration[5.2]
  def change
    change_column :events, :user_id, :string
  end
end
