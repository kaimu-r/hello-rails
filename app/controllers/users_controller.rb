class UsersController < ApplicationController
  # ユーザー一覧ページ
  def index
    @users = User.all
  end

  # ユーザー詳細ページ
  def show
    @user = set_user
  end

  # 新規ユーザー作成ページ
  def new
    @user = User.new
  end

  # 新規ユーザー作成
  def create
    @user = User.new(user_params)

    if @user.save
      # ユーザー詳細にリダイレクト
      # 【redirect_to 参考文献】https://api.rubyonrails.org/classes/ActionController/Redirecting.html#method-i-redirect_to
      redirect_to @user
    else
      # ユーザー新規作成ページにリダイレクトしてエラーメッセージを表示
      # 【render 参考文献】https://api.rubyonrails.org/classes/ActionController/Rendering.html#method-i-render
      # 【Railsガイド render】https://railsguides.jp/layouts_and_rendering.html#render%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%82%92%E4%BD%BF%E3%81%86
      render :new, status: :unprocessable_entity
    end
  end

  # ユーザー編集ページ
  def edit
    @user = set_user
  end

  # ユーザー編集
  def update
    @user = set_user

    # ユーザーの更新処理を行う
    if @user.update(user_params)
      # ユーザー詳細ページにリダイレクト
      redirect_to @user
    else
      # ユーザー編集ページにリダイレクトしてエラーメッセージを表示
      render :edit, status: :unprocessable_entity
    end
  end

  # ユーザー削除
  def destroy
    @user = set_user
    # ユーザーの削除を実行
    @user.destroy

    redirect_to users_path, status: :see_other
  end

  private
    # 新規作成・更新時に受け取って良いパラメータを定義
    def user_params
      # paramsからuserキーのname属性のみを許可
      #【Railsガイド paramsについて】https://railsguides.jp/action_controller_overview.html#%E3%83%91%E3%83%A9%E3%83%A1%E3%83%BC%E3%82%BF
      #【Rails API ActionController::Parameters】https://api.rubyonrails.org/v8.0/classes/ActionController/Parameters.html
      params.require(:user).permit(:name)
    end

    # idに基づいてユーザーを取得
    def set_user
      # ユーザーをIDで検索
      #【Railsガイド Active Record】https://railsguides.jp/v7.0/active_record_basics.html
      @user = User.find(params[:id])
    end
end
