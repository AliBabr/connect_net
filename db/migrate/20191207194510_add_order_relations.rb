class AddOrderRelations < ActiveRecord::Migration[5.2]
  def change
    add_reference(:orders, :job, index: false)
    add_reference(:orders, :application, index: false)
  end
end
