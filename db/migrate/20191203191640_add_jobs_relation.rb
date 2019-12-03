class AddJobsRelation < ActiveRecord::Migration[5.2]
  def change
    add_reference(:jobs, :user, index: false)
  end
end
