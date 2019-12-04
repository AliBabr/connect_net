class AddArticleRelatio < ActiveRecord::Migration[5.2]
  def change
    add_reference(:articles, :user, index: false)
  end
end
