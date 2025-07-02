class AddImageBase64ToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :image_base64, :text
    add_column :users, :image_content_type, :string
  end
end
