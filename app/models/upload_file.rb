class UploadFile < ApplicationRecord
  # ユーザーに対して画像は一枚のみ設定できるようにする
  has_one :user

  # アップロードする画像のタイプを`image/jpeg`と`image/png`のみに指定
  validates :content_type, inclusion: { in: ["image/jpeg", "image/png"] }

  # 画像のファイルサイズを2MG以下に設定
  validates :byte_size, numericality: { less_than_or_equal_to: 2.megabytes }

  def self.create_and_store(upload)
    # アップロードされたデータからレコードを作成
    # upload => ActionDispatch::Http::UploadedFile
    record = create(
      key: SecureRandom.hex(16),
      filename: upload.original_filename,
      content_type: upload.content_type,
      byte_size: upload.size
    )

    # キーを参考にしてディレクトリを作成する
    FileUtils.mkdir_p(File.dirname(record.storage_path))

    # アップロードされたファイルをFIleオブジェクトに変換して、key元に作成したディレクトリにファイルをコピーする
    IO.copy_stream(upload.tempfile, record.storage_path)

    # upload_fileのレコードを返す
    record
  end

  def storage_path
    Rails.root.join("storage", "uploads", key[0..1], key[2..3], key)
  end
end
