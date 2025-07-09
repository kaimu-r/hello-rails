class Admin::LoginsController < Admin::ApplicationController
    def new
      # ログインフォームを表示するのみ
    end

    def create
      # メールアドレスで本人確認を行い、ログイン状態にする
      admin = Admin.find_by(email: params[:email])

      if admin
        session[:admin_id] = admin.id
        redirect_to admin_users_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      # ログアウトの処理
    end
end
