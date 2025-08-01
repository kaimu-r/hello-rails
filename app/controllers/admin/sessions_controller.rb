module Admin
  class SessionsController < Admin::ApplicationController
    skip_before_action :require_login, only: %i[new create]
    def new
      # ログインフォームを表示するのみ
    end

    def create
      admin_user = AdminUser.find_by(email: params[:email])

      return render :new, status: :unprocessable_entity if admin_user.nil?

      if admin_user.authenticate(params[:password])
        reset_session
        session[:admin_user_id] = admin_user.id
        redirect_to admin_users_url
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      # ログアウトの処理
      session.delete(:admin_user_id)

      redirect_to new_admin_login_url
    end
  end
end
