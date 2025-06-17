class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 空の値はバリデーションをスキップする
    return if value.blank?

    # 10桁または11桁の数字のみを許可
    phone_regex = /\A\d{10,11}\z/

    # 正規表現にマッチしない場合はエラーメッセージを追加
    unless value.match?(phone_regex)
      record.errors.add(attribute, "は10〜11桁の数字で入力してください")
    end
  end
end
