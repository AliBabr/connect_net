class ChangeUserIdTypeForMusic < ActiveRecord::Migration[5.2]
  def change
    change_column :musics, :user_id, :string
  end
end
