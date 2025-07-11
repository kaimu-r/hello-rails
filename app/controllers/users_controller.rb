class UsersController < ApplicationController
  # ユーザー一覧ページ
  def index
    @users = User.all
    @prefectures = User.prefectures

    # veiwテンプレートで使用するためインスタンス変数で定義
    @param_name = params[:name]
    @param_pref = params[:pref]
    @param_birth = params[:birth]
    @param_per = params[:per]

    # 検索フォームから検索条件のクエリパラメータを取得し、検索を行っていく処理
    @users = @users.search_by_full_name(@param_name) if @param_name.present?

    @users = @users.search_by_prefecture(@param_pref) if @prefectures.value?(@param_pref)

    @users = @users.order_by_birth_date(@param_birth) if ["asc", "desc"].include?(@param_birth)

    # kaminariのページネーションを追加して、表示件数の制御を行う
    @users = @users.order(:full_name).page(params[:page])

    @users = @users.per(@param_per) if ["10", "50", "100"].include?(@param_per)
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
