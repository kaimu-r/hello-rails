class AddUserInfoToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      # 基本情報
      t.rename :name, :full_name # フルネーム
      t.string :full_name_kana # フルネーム(カナ)
      t.integer :gender # 性別(0: 男性, 1: 女性, 2: その他)

      # 連絡先情報
      t.string :email # メールアドレス
      t.string :home_phone # 自宅電話
      t.string :mobile_phone # 携帯電話

      # 住所情報
      t.string :postal_code # 郵便番号
      t.string :prefecture # 都道府県
      t.string :city # 市区町村
      t.string :town # 町名
      t.string :address_block # 番地
      t.string :building # 建物名・部屋番号

      # 生年月日
      t.date :birth_date
    end
  end
end
