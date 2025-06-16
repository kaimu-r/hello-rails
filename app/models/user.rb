class User < ApplicationRecord
    # ユーザーの性別
    enum :gender, { male: 0, female: 1, other: 2 }

    validates :full_name,
              presence: true, # full_nameは必須
              length: { maximum: 50 } # full_nameの最大文字数は50

    validates :full_name_kana,
              presence: true, # full_name_kanaは必須
              length: { maximum: 50 } # full_name_kanaの最大文字数は50

    validates :gender,
              presence: true, # genderは必須
              inclusion: { in: genders.keys } # genderは男性、女性、その他のいずれかであることを検証

    validates :birth_date,
              presence: true, # birth_dateは必須
              comparison: { less_than_or_equal_to: Date.today} # 今日以前の日付であることを検証

    validates :email,
              presence: true, # emailは必須
              format: { with: URI::MailTo::EMAIL_REGEXP }, # メールアドレスの形式が正しいことを検証
              uniqueness: { case_sensitive: false } # emailは一意であることを検証(大文字小文字を区別しない)

    validates :home_phone,
              presence: true # home_phoneは必須

    validates :mobile_phone,
              presence: true # mobile_phoneは必須

    validates :postal_code,
              presence: true, # postal_codeは必須
              length: { maximum: 7 } # 最大文字数は7 参考: https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%83%B5%E4%BE%BF%E7%95%AA%E5%8F%B7

    validates :prefecture,
              presence: true # prefectureは必須

    validates :city,
              presence: true, # cityは必須
              length: { maximum: 20 } # 最大文字数は20

    validates :town,
              length: { maximum: 20 }, # 最大文字数は20
              presence: true # townは必須

    validates :address_block,
              length: { maximum: 50 }, # 最大文字数は50
              presence: true # address_blockは必須

    validates :building,
              length: { maximum: 50 }, # 最大文字数は50
              allow_blank: true # buildingは空でも良い
end
