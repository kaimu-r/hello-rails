class Admin::ApplicationController < ActionController::Base
  layout 'admin/application'

  before_action :require_login
  helper_method :current_admin_user, :logged_in?

  private
    def current_admin_user
      @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id])
    end

    def logged_in?
      current_admin_user != nil
    end

    # ログインユーザーが存在しない場合はログイン画面にリダイレクトする
    def require_login
      if !logged_in?
        redirect_to new_admin_login_path
      end
    end
end
