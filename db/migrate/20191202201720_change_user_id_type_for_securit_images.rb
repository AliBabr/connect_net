class ChangeUserIdTypeForSecuritImages < ActiveRecord::Migration[5.2]
  def change
    change_column :user_security_images, :user_id, :string
  end
end
