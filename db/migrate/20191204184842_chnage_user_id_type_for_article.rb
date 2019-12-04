class ChnageUserIdTypeForArticle < ActiveRecord::Migration[5.2]
  def change
    change_column :articles, :user_id, :string
  end
end
