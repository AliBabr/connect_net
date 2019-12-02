class CreateUserSecurityImages < ActiveRecord::Migration[5.2]
  def change
    create_table :user_security_images do |t|

      t.timestamps
    end
  end
end
