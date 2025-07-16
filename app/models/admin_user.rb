class AdminUser < ApplicationRecord
  def self.from_auth(access_token)
    find_or_create_by(email: access_token.info["email"])
  end
end
