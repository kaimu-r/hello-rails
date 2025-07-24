module Admin
  class AuthCallbacksController < Admin::ApplicationController
    skip_before_action :require_login

    def google_oauth2
      email = request.env['omniauth.auth'].info['email']

      # メールアドレスが`rizapgroup.com`ではない場合はログインを許可しない。
      return redirect_to new_admin_login_path unless email.end_with?('rizapgroup.com')

      admin_user = AdminUser.find_or_create_by!(email:)

      reset_session
      session[:admin_user_id] = admin_user.id
      redirect_to admin_users_url
    end
  end
end
