class ChabgeUserIdTypeForJobs < ActiveRecord::Migration[5.2]
  def change
    change_column :jobs, :user_id, :string
  end
end
