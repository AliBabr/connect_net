class AddNameToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string
  end
end
