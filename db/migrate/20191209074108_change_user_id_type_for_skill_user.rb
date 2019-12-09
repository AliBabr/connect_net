class ChangeUserIdTypeForSkillUser < ActiveRecord::Migration[5.2]
  def change
    change_column :skills_users, :user_id, :string
  end
end
