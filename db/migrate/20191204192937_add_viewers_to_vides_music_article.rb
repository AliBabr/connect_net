class AddViewersToVidesMusicArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :total_viewers, :integer
    add_column :articles, :total_viewers, :integer
    add_column :musics, :total_listioner, :integer
  end
end
