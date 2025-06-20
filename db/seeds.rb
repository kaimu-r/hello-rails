# 部署のシードデータ
departments = [
  "コーポレート統括部",
  "DX推進本部",
  "情報システム部",
  "プロダクト開発統括1部",
  "プロダクト開発統括2部",
  "プロダクト企画統括部",
  "IoT統括部",
  "データマネジメント部",
  "デジタルマーケティング部",
  "企画室"
]

departments.each do |department_name|
  Department.create(name: department_name)
end
