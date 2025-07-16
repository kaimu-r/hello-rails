class AdminUser < ApplicationRecord
  def self.from_auth(access_token)
    find_or_create_by(email: access_token.info["email"])
  end
  has_secure_password

  validates :email,
            presence: { message: "を入力してください" },
            format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, message: "は不正なメールアドレスです" },
            uniqueness: { case_sensitive: false, message: "はすでに存在します" }
  
  validates :password,
            presence: { message: "を入力してください" },
            length: { minimum: 6, message: "は6文字以上で入力してください" }
end
