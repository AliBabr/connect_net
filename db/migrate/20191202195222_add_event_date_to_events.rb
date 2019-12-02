class AddEventDateToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :event_date, :string
    add_column :events, :event_time, :string
  end
end
