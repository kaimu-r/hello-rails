class Admin::UsersController < Admin::ApplicationController
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

  # 新規ユーザー作成ページ
  def new
    @user = User.new
    @departments = Department.all
    @skills = Skill.all
  end

  # 新規ユーザー作成
  def create
    @user = User.new(user_params)
    @departments = Department.all
    @skills = Skill.all

    if @user.save
      # ユーザー詳細にリダイレクト
      # 【redirect_to 参考文献】https://api.rubyonrails.org/classes/ActionController/Redirecting.html#method-i-redirect_to
      redirect_to admin_user_url(@user)
    else
      # ユーザー新規作成ページにリダイレクトしてエラーメッセージを表示
      # 【render 参考文献】https://api.rubyonrails.org/classes/ActionController/Rendering.html#method-i-render
      # 【Railsガイド render】https://railsguides.jp/layouts_and_rendering.html#render%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%82%92%E4%BD%BF%E3%81%86
      render :new, status: :unprocessable_entity
    end
  end

  # ユーザー編集ページ
  def edit
    @user = User.find(params[:id])
    @departments = Department.all
    @skills = Skill.all
  end

  # ユーザー編集
  def update
    @user = User.find(params[:id])
    @departments = Department.all
    @skills = Skill.all

    # ユーザーの更新処理を行う
    if @user.update(user_params)
      # ユーザー詳細ページにリダイレクト
      redirect_to admin_user_url(@user)
    else
      # ユーザー編集ページにリダイレクトしてエラーメッセージを表示
      render :edit, status: :unprocessable_entity
    end
  end

  # ユーザー削除
  def destroy
    @user = User.find(params[:id])
    # ユーザーの削除を実行
    @user.destroy

    redirect_to admin_users_path, status: :see_other
  end

  private
    # 新規作成・更新時に受け取って良いパラメータを定義
    def user_params
      # params.require(:user)で`user`キーを必須とし、permitメソッドで許可する属性を指定
      #【Railsガイド paramsについて】https://railsguides.jp/action_controller_overview.html#%E3%83%91%E3%83%A9%E3%83%A1%E3%83%BC%E3%82%BF
      #【Rails API ActionController::Parameters】https://api.rubyonrails.org/v8.0/classes/ActionController/Parameters.html
      params
        .require(:user)
        .permit(
          :full_name, :full_name_kana, :gender, :birth_date,
          :email, :home_phone, :mobile_phone, :postal_code,
          :prefecture, :city, :town, :address_block, :building,
          :department_id, :image, skill_ids: []
        )
    end
end
