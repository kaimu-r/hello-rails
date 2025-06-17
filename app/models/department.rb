class Department < ApplicationRecord
    # 部署は複数のユーザーを持つ
    has_many :users
end
