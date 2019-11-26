class AddRolesRelation < ActiveRecord::Migration[5.2]
  def change
    add_reference(:roles, :user, index: false)
  end
end
