class AddApplicationsRelations < ActiveRecord::Migration[5.2]
  def change
    add_reference(:applications, :user, index: false)
    add_reference(:applications, :job, index: false)
  end
end
