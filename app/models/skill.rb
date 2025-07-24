class Skill < ApplicationRecord
  # スキルはUserSkillsモデルを経由して複数のユーザーが取得できる
  has_many :user_skills
  has_many :users, through: :user_skills

  validates :name,
            presence: { message: 'を入力してください' }, # nameは必須
            length: { maximum: 50, message: 'は50文字以内で入力してください' }, # nameの最大文字数は50
            uniqueness: { message: 'はすでに存在します' }
end
