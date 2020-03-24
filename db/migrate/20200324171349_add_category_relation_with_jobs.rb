class AddCategoryRelationWithJobs < ActiveRecord::Migration[5.2]
  def change
    add_reference(:jobs, :category, index: false)
  end
end
