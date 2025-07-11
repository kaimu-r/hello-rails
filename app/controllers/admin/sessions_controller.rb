class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  def new
    # ログインフォームを表示するのみ
  end

  def create
    # メールアドレスで本人確認を行い、ログイン状態にする
    admin = Admin.find_by(email: params[:email])

    if admin
      reset_session
      session[:admin_id] = admin.id
      redirect_to admin_users_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # ログアウトの処理
    session.delete(:admin_id)

    redirect_to new_admin_login_url
  end
end
