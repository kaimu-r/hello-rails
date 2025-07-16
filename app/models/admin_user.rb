class AdminUser < ApplicationRecord
  has_secure_password

  validates :email,
            presence: { message: "を入力してください" },
            format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, message: "は不正なメールアドレスです" },
            uniqueness: { case_sensitive: false, message: "はすでに存在します" }
  
  validates :password,
            presence: { message: "を入力してください" },
            length: { minimum: 6, message: "は6文字以上で入力してください" }
end
