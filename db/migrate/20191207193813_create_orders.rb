class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer   :price
      t.string   :completion_time
      t.string   :payment_status
      t.timestamps
    end
  end
end
