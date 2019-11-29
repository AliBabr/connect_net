class LikesRelations < ActiveRecord::Migration[5.2]
  def change
    add_reference(:likes, :user, index: false)
    add_reference(:likes, :post, index: false)
  end
end
