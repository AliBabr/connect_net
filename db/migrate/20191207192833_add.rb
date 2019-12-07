class Add < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :status, :string
    add_column :jobs, :price, :string
    add_column :jobs, :deadline, :string
    add_column :applications, :status, :string
  end
end
