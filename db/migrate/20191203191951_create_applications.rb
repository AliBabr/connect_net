class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string   :cover_description
      t.string   :bid_price
      t.string   :required_days
      t.timestamps
    end
  end
end
