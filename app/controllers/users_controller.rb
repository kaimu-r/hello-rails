class UsersController < ApplicationController
    # ユーザー一覧ページ
  def index
    @users = User.all
  end

    # ユーザー詳細ページ
  def show
    @user = User.find(params[:id])
    @skills = @user.skills
  end
end
