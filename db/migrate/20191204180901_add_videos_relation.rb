class AddVideosRelation < ActiveRecord::Migration[5.2]
  def change
    add_reference(:videos, :user, index: false)
  end
end
