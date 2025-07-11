class CreateAdminUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_users do |t|
      t.string :email, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
