class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      # ユーザーの名前を保存するカラム
      t.string :name

      # created_at / updated_at の2つの日時カラムを自動生成
      t.timestamps
    end
  end
end
