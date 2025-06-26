class Department < ApplicationRecord
    # 部署は複数のユーザーを持つ
    has_many :users, dependent: :nullify

    validates :name,
              presence: { message: "を入力してください" }, # nameは必須
              length: { maximum: 50, message: "は50文字以内で入力してください" }, # nameの最大文字数は50
              uniqueness: { message: "はすでに存在します" }
end
