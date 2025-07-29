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
    hokkaido: '北海道', aomori: '青森県', iwate: '岩手県', miyagi: '宮城県',
    akita: '秋田県', yamagata: '山形県', fukushima: '福島県', ibaraki: '茨城県',
    tochigi: '栃木県', gunma: '群馬県', saitama: '埼玉県', chiba: '千葉県',
    tokyo: '東京都', kanagawa: '神奈川県', niigata: '新潟県', toyama: '富山県',
    ishikawa: '石川県', fukui: '福井県', yamanashi: '山梨県', nagano: '長野県',
    gifu: '岐阜県', shizuoka: '静岡県', aichi: '愛知県', mie: '三重県',
    shiga: '滋賀県', kyoto: '京都府', osaka: '大阪府', hyogo: '兵庫県',
    nara: '奈良県', wakayama: '和歌山県', tottori: '鳥取県', shimane: '島根県',
    okayama: '岡山県', hiroshima: '広島県', yamaguchi: '山口県', tokushima: '徳島県',
    kagawa: '香川県', ehime: '愛媛県', kochi: '高知県', fukuoka: '福岡県',
    saga: '佐賀県', nagasaki: '長崎県', kumamoto: '熊本県', oita: '大分県',
    miyazaki: '宮崎県', kagoshima: '鹿児島県', okinawa: '沖縄県'
  }

  validates :full_name,
            presence: { message: 'を入力してください' },
            length: { maximum: 50 }

  validates :full_name_kana,
            presence: { message: 'を入力してください' },
            length: { maximum: 50 }

  validates :gender,
            presence: { message: 'を選択してください' },
            inclusion: { in: genders.keys, allow_blank: true, message: '不正な値です' }

  validates :birth_date,
            presence: { message: 'を入力してください' },
            comparison: { less_than_or_equal_to: proc {
              Date.today
            }, allow_blank: true, message: 'は今日以前の日付である必要があります' }

  validates :email,
            presence: { message: 'を入力してください' },
            format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, message: 'は不正なメールアドレスです' },
            uniqueness: { case_sensitive: false, message: 'はすでに存在します' }

  validates :home_phone,
            presence: { message: 'を入力してください' },
            phone_format: true

  validates :mobile_phone,
            phone_format: true,
            uniqueness: { allow_blank: true, message: 'はすでに存在します' }

  validates :postal_code,
            presence: { message: 'を入力してください' },
            length: { maximum: 7, message: 'は7桁以内で入力してください' }

  validates :prefecture,
            presence: { message: 'を入力してください' }

  validates :city,
            presence: { message: 'を入力してください' },
            length: { maximum: 20, message: 'は20文字以内で入力してください' }

  validates :town,
            presence: { message: 'を入力してください' },
            length: { maximum: 20, message: 'は20文字以内で入力してください' }

  validates :address_block,
            presence: { message: 'を入力してください' },
            length: { maximum: 50, message: 'は50文字以内で入力してください' }

  validates :building,
            length: { maximum: 50, message: 'は50文字以内で入力してください' }

  # imageフィールドのバリデーションチェック
  validate :image_validate

  # バリデーション実行後の処理

  # imageフィールドをバイナリデータに変換する
  after_validation :extract_image_binary

  # 検索用のクエリを発行するメソッドを作成する
  # scopeメソッドを使用してActiveRecord::Relationオブジェクトを返しクエリの構築を行う
  scope :search_by_full_name, ->(full_name) { where("full_name LIKE ?", full_name + "%") if full_name.present? }

  scope :search_by_prefecture, ->(prefecture) { where('prefecture = ?', prefecture) if prefectures.value?(prefecture) }

  # order_typeには`asc`または`desc`が入る
  scope :order_by_birth_date, ->(order_type) { order(birth_date: order_type) if %w[asc desc].include?(order_type) }

  private

  # imageフィールドがActionDispatch::Http::UploadedFileクラスまたはそのサブクラスでない場合は何もしない
  # imageフィールドにはバイナリデータが渡る場合もある（ファイルをフィールドに入れずにリクエストを送信した場合）ためクラスを指定する
  def image_uploaded_file?
    image.is_a?(ActionDispatch::Http::UploadedFile)
  end

  def image_validate
    return unless image_uploaded_file?

    # 画像のファイルサイズが64KB以下かどうかをチェックする
    errors.add(:image, 'は64KB以下にしてください') if image.size > 64.kilobytes

    # MIMEタイプがimage/pngのみアップロード可能にする
    return if image.content_type.match('image/png')

    errors.add(:image, 'はPNG形式のみアップロードできます')
  end

  # 画像データをバイナリデータに変換する処理
  def extract_image_binary
    return unless image_uploaded_file?

    # 画像の読み込みを行いバイナリデータを格納する
    self.image = image.read
  end
end
