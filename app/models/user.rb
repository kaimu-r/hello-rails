class User < ApplicationRecord
    # ユーザーの`name`が空でないことを検証
    validates :name, presence: true
end
