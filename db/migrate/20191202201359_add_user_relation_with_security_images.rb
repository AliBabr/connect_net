class AddUserRelationWithSecurityImages < ActiveRecord::Migration[5.2]
  def change
    add_reference(:user_security_images, :user, index: false)
  end
end
