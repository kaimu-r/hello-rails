class ImagesController < ActionController::Base
  def show
    # keyパラメータによってファイルを取得し、存在しない場合は404エラーを返す。
    file = UploadFile.find_by!(key: params[:key])

    # ファイルを送信する
    # ブラウザで保存する際のファイル名をDBに保存されているファイル名に指定
    # ファイルはインライン表示に指定。`attachment`にするとダウンロードされるようになる。
    # MIMEタイプを指定
    send_file file.storage_path,
              filename:    file.filename,
              disposition: :inline,
              type:        file.content_type
  end
end
