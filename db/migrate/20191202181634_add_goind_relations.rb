class AddGoindRelations < ActiveRecord::Migration[5.2]
  def change
    add_reference(:goings, :user, index: false)
    add_reference(:goings, :event, index: false)
  end
end
