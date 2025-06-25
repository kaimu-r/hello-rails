require 'csv'

desc "CSV をインポートして User を作成する。lib/data配下のファイルを参照。"
task :import, [:file] do |_, args|
  file = Rails.root.join('lib', 'data', args.file)
  abort "ファイルが見つかりません。" unless File.exist?(file)

  puts "インポート！ file=#{file}"

  rows = CSV.read(file, headers: true)

  rows.each_slice(1000) do |batch|
    User.insert_all(batch.map { |row| row.to_h })
  end

  puts "完了！"
end
