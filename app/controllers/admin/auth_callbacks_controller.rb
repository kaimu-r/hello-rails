class Admin::AuthCallbacksController < Admin::ApplicationController
  skip_before_action :require_login

  def google_oauth2
    admin_user = AdminUser.from_auth(request.env['omniauth.auth'])

    if admin_user.persisted?
      reset_session
      session[:admin_user_id] = admin_user.id
      redirect_to admin_users_url
    else
      redirect_to new_admin_login_path
    end
  end
end
