# frozen_string_literal: true

require 'test_helper'

module Admin
  class AdminUsersControllerTest < ActionDispatch::IntegrationTest
    test '#new 新規登録ページにアクセスできる' do
      get new_admin_login_url
      assert_response :success
    end

    test '#create 新しい管理者ユーザーを作成できる' do
      assert_difference(['AdminUser.count']) do
        post admin_admin_users_url, params: {
          admin_user: {
            email: 'new_admin_user_test@example.com',
            password: '12345678',
            password_confirmation: '12345678'
          }
        }
      end

      assert_response :redirect
    end
  end
end
