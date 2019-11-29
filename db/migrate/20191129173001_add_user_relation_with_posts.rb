class AddUserRelationWithPosts < ActiveRecord::Migration[5.2]
  def change
    add_reference(:posts, :user, index: false)
  end
end
