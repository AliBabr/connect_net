class ChangeCustomerName < ActiveRecord::Migration[5.2]
  def change
    rename_column :feedbacks, :cutomer_rating, :customer_rating
  end
end
