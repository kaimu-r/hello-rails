class AddPasswordToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :password_digest, :string, null: true, after: :email
  end
end
