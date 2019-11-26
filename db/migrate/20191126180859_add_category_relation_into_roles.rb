class AddCategoryRelationIntoRoles < ActiveRecord::Migration[5.2]
  def change
    add_reference(:roles, :category, index: false)
  end
end
