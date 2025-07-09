class Admin::ApplicationController < ActionController::Base
  layout 'admin/application'

  private
    # ログイン中のユーザーを取得する。
    def current_admin
      @_current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
    end

    # ログインユーザーが存在しない場合はログイン画面にリダイレクトする
    def login_check
      redirect_to new_admin_login_path unless current_admin
    end
end
