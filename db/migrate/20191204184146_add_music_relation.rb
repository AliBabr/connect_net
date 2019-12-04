class AddMusicRelation < ActiveRecord::Migration[5.2]
  def change
    add_reference(:musics, :user, index: false)
  end
end
