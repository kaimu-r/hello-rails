class AddDepartmentRefToUsers < ActiveRecord::Migration[7.0]
  def change
    # ユーザーテーブルに部署の参照を追加
    add_reference :users, :department, foreign_key: true
  end
end
