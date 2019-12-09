class ChangeLatLong < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :lat
    remove_column :users, :long
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end
