class AddFeedbackRelation < ActiveRecord::Migration[5.2]
  def change
    add_reference(:feedbacks, :job, index: false)
  end
end
