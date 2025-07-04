class UsersController < ApplicationController
  # ユーザー一覧ページ
  def index
    @users = User.order(:full_name).page params[:page]
  end

  # ユーザー詳細ページ
  def show
    @user = User.find(params[:id])
    @skills = @user.skills
  end

  # ユーザー画像表示アクション
  def image
    user = User.find(params[:id])

    send_data user.image, filename: "user_image", type: "image/png", disposition: "inline"
  end
end
