class UsersController < ApplicationController
  # ユーザー一覧ページ
  def index
    @prefectures = User.prefectures

    # veiwテンプレートで使用するためインスタンス変数で定義
    @search_params = search_params

    # 検索フォームから検索条件のクエリパラメータを取得し、検索を行っていく処理
    @users = User
             .search_by_full_name(@search_params[:name])
             .search_by_prefecture(@search_params[:pref])
             .order_by_birth_date(@search_params[:birth])
             .order(:full_name)
             # kaminariのページネーションを追加して、表示件数の制御を行う
             .page(@search_params[:page])
             .per(per_page(@search_params[:per]))
  end

  # ユーザー詳細ページ
  def show
    @user = User.find(params[:id])
    @skills = @user.skills
  end

  # ユーザー画像表示アクション
  def image
    user = User.find(params[:id])

    send_data user.image, filename: 'user_image', type: 'image/png', disposition: 'inline'
  end
end
