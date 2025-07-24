class ChangeFullNameIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :full_name
    add_index :users, :birth_date
  end
end
