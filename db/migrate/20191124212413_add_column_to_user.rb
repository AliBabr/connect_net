class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :lat, :string
    add_column :users, :long, :string
    add_column :users, :coming_from, :string
    rename_column :users, :authentication_token, :social_token
  end
end
