class RenameTypeForRole < ActiveRecord::Migration[5.2]
  def change
    rename_column :roles, :type, :role_type
  end
end
