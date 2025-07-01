class AddUploadFileIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :upload_file, null: true, foreign_key: true
  end
end
