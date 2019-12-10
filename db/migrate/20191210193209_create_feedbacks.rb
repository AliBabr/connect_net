class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.string :professional_id
      t.string :customer_id
      t.string :customer_feedback
      t.string :professional_feedback
      t.integer :cutomer_rating
      t.integer :professional_rating
      t.timestamps
    end
  end
end
