class CommentsRelations < ActiveRecord::Migration[5.2]
  def change
    add_reference(:comments, :user, index: false)
    add_reference(:comments, :post, index: false)
  end
end
