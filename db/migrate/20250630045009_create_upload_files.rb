class CreateUploadFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :upload_files do |t|
      t.string :key, null: false
      t.string :filename, null: false
      t.string :content_type, null: false
      t.bigint :byte_size, null: false

      t.timestamps
    end

    add_index :upload_files, :key, unique: true
  end
end
