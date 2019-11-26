class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.boolean   :active , default: false
      t.timestamps
    end
  end
end
