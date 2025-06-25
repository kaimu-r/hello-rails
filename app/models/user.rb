class User < ApplicationRecord
    # ユーザーは1つの部署に所属する
    belongs_to :department

    # ユーザーはUserSkillsモデルを経由して複数のスキルを所有する
    has_many :user_skills
    has_many :skills, through: :user_skills

    # ユーザーの性別
    enum :gender, { male: 0, female: 1, other: 2 }

    validates :full_name,
              presence: { message: "を入力してください" }, # full_nameは必須
              length: { maximum: 50 } # full_nameの最大文字数は50

    validates :full_name_kana,
              presence: { message: "を入力してください" }, # full_name_kanaは必須
              length: { maximum: 50 } # full_name_kanaの最大文字数は50

    validates :gender,
              presence: { message: "を選択してください" }, # genderは必須
              inclusion: { in: genders.keys, allow_blank: true, message: "不正な値です" } # genderは男性、女性、その他のいずれかであることを検証

    validates :birth_date,
              presence: { message: "を入力してください" }, # birth_dateは必須
              comparison: { less_than_or_equal_to: Proc.new{ Date.today }, allow_blank: true, message: "は今日以前の日付である必要があります" } # 今日以前の日付であることを検証

    validates :email,
              presence: { message: "を入力してください" }, # emailは必須
              format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, message: "は不正なメールアドレスです" }, # メールアドレスの形式が正しいことを検証
              uniqueness: { case_sensitive: false, message: "はすでに存在します" } # emailは一意であることを検証(大文字小文字を区別しない)

    validates :home_phone,
              presence: { message: "を入力してください" }, # home_phoneは必須
              phone_format: true # 電話番号の形式を検証

    validates :mobile_phone,
              phone_format: true, # 電話番号の形式を検証
              uniqueness: { allow_blank: true, message: "はすでに存在します" } # 一意であることを検証

    validates :postal_code,
              presence: { message: "を入力してください" }, # postal_codeは必須
              length: { maximum: 7, message: "は7桁以内で入力してください" } # 最大文字数は7 参考: https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%83%B5%E4%BE%BF%E7%95%AA%E5%8F%B7

    validates :prefecture,
              presence: { message: "を入力してください" } # prefectureは必須

    validates :city,
              presence: { message: "を入力してください" }, # cityは必須
              length: { maximum: 20, message: "は20文字以内で入力してください" } # 最大文字数は20

    validates :town,
              presence: { message: "を入力してください" }, # townは必須
              length: { maximum: 20, message: "は20文字以内で入力してください" } # 最大文字数は20

    validates :address_block,
              presence: { message: "を入力してください" }, # address_blockは必須
              length: { maximum: 50, message: "は50文字以内で入力してください" } # 最大文字数は50

    validates :building,
              length: { maximum: 50, message: "は50文字以内で入力してください" } # 最大文字数は50
end
