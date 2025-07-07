class User < ApplicationRecord
    # ユーザーは1つの部署に所属する
    belongs_to :department

    # ユーザーはUserSkillsモデルを経由して複数のスキルを所有する
    has_many :user_skills
    has_many :skills, through: :user_skills

    # ユーザーの性別
    enum :gender, { male: 0, female: 1, other: 2 }

    # 都道府県のENUM
    enum :prefecture, {
      hokkaido: "北海道", aomori: "青森県", iwate: "岩手県", miyagi: "宮城県",
      akita: "秋田県", yamagata: "山形県", fukushima: "福島県", ibaraki: "茨城県",
      tochigi: "栃木県", gunma: "群馬県", saitama: "埼玉県", chiba: "千葉県",
      tokyo: "東京都", kanagawa: "神奈川県", niigata: "新潟県", toyama: "富山県",
      ishikawa: "石川県", fukui: "福井県", yamanashi: "山梨県", nagano: "長野県",
      gifu: "岐阜県", shizuoka: "静岡県", aichi: "愛知県", mie: "三重県",
      shiga: "滋賀県", kyoto: "京都府", osaka: "大阪府", hyogo: "兵庫県",
      nara: "奈良県", wakayama: "和歌山県", tottori: "鳥取県", shimane: "島根県",
      okayama: "岡山県", hiroshima: "広島県", yamaguchi: "山口県", tokushima:"徳島県",
      kagawa: "香川県", ehime: "愛媛県", kochi: "高知県", fukuoka: "福岡県",
      saga: "佐賀県", nagasaki: "長崎県", kumamoto: "熊本県", oita: "大分県",
      miyazaki: "宮崎県", kagoshima: "鹿児島県", okinawa: "沖縄県"
    }

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
    
    # imageフィールドのバリデーションチェック
    validate :image_validate

    # バリデーション実行後の処理

    # imageフィールドをバイナリデータに変換する
    after_validation :extract_image_binary


    private

      # imageフィールドがActionDispatch::Http::UploadedFileクラスまたはそのサブクラスでない場合は何もしない
      # imageフィールドにはバイナリデータが渡る場合もある（ファイルをフィールドに入れずにリクエストを送信した場合）ためクラスを指定する
      def image_uploaded_file?
        image.is_a?(ActionDispatch::Http::UploadedFile)
      end

      def image_validate
        return unless image_uploaded_file?

        # 画像のファイルサイズが64KB以下かどうかをチェックする
        if image.size > 64.kilobytes
          errors.add(:image, "は64KB以下にしてください")
        end

        # MIMEタイプがimage/pngのみアップロード可能にする
        unless image.content_type.match("image/png")
          errors.add(:image, 'はPNG形式のみアップロードできます')
        end
      end

      # 画像データをバイナリデータに変換する処理
      def extract_image_binary
        return unless image_uploaded_file?
        # 画像の読み込みを行いバイナリデータを格納する
        self.image = self.image.read
      end
end
