desc "CSV をインポートして User を作成する"
namespace :users do
  task :import, [:file_path] => :environment do |_, args|
    abort "ファイルパスを指定してください。" unless args.file_path

    file_path = Rails.root.join(args.file_path)
    abort "ファイルが見つかりません。" unless File.exist?(file_path)

    # 件数をカウントする変数
    imported_num = 0 # 新規登録に成功
    failed_num = 0 # バリデーションエラーなどで失敗
    duplicated_num = 0  # emailが既に存在していてスキップ

    # department_idをランダムに割り当てるため、事前に全てのIDを取得する
    department_ids = Department.pluck(:id)

    puts "インポート スタート！"
    CSV.foreach(file_path, headers: true) do |row|
      # 同じメールアドレスが登録されている場合はスキップ
      if User.exists?(email: row["email"])
        duplicated_num += 1
        next
      end

      begin
        User.create!(
          full_name: row["full_name"],
          full_name_kana: row["full_name_kana"],
          gender: row["gender"] == "男" ? :male : :female,
          home_phone: row["home_phone"],
          mobile_phone: row["mobile_phone"],
          email: row["email"],
          postal_code: row["postal_code"],
          prefecture: row["prefecture"],
          city: row["city"],
          town: row["town"],
          address_block: row["address_block"],
          building: row["building"],
          birth_date: row["birth_date"],
          department_id: department_ids.sample
        )
        imported_num += 1
      rescue ActiveRecord::RecordInvalid => e
        failed_num += 1
        puts "import users error : #{e.record.errors.full_messages.join(', ')}"
      end
    end

    puts "ユーザーのインポートが完了しました！ 新規登録: #{imported_num} 重複スキップ: #{duplicated_num}, 失敗: #{failed_num}"
  end
end
