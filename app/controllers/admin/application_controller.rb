class Admin::ApplicationController < ActionController::Base
  layout 'admin/application'

  before_action :require_login
  helper_method :current_user, :logged_in?

  private
    def current_user
      @current_user ||= Admin.find_by(id: session[:admin_id])
    end

    def logged_in?
      current_user != nil
    end

    # ログインユーザーが存在しない場合はログイン画面にリダイレクトする
    def require_login
      if !logged_in?
        redirect_to new_admin_login_path
      end
    end
end
