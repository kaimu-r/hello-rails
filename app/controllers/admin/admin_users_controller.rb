# frozen_string_literal: true

module Admin
  class AdminUsersController < Admin::ApplicationController # :nodoc:
    skip_before_action :require_login, only: %i[new create]

    def new
      @admin_user = AdminUser.new
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)

      if @admin_user.save
        redirect_to new_admin_login_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def admin_user_params
      params
        .require(:admin_user)
        .permit(:email, :password, :password_confirmation)
    end
  end
end
