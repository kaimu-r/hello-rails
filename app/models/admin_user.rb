class AdminUser < ApplicationRecord
  def self.from_auth(access_token)
    data = access_token.info

    user = where(email: data["email"]).first
    user = create(email: data["email"], password_digest: "12345678") if user.blank?
  end
end
