class UsersController < ApplicationController
  # ユーザー一覧ページ
  def index
    @users = User.all
    @prefectures = User.prefectures

    # 検索フォームから検索条件のクエリパラメータを取得し、検索を行っていく処理
    @users = @users.search_by_full_name(params[:name]) if params[:name].present?

    @users = @users.search_by_prefecture(params[:pref]) if @prefectures.value?(params[:pref])

    @users = @users.order_by_birth_date(params[:birth]) if ["asc", "desc"].include?(params[:birth])

    # kaminariのページネーションを追加して、表示件数の制御を行う
    @users = @users.order(:full_name).page(params[:page])

    @users = @users.per(params[:per]) if ["10", "50", "100"].include?(params[:per])
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
