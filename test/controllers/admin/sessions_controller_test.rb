require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#new ログインページにアクセスできる" do
    get new_admin_login_url
    assert_response :success
  end

  test "#create 管理者がログインできる" do
    admin_user = AdminUser.create!(email: "test_admin_user@example.com", password: "12345678")
    login_as(admin_user)

    # ログイン後に管理画面の従業員一覧画面にリダイレクトし、セッションのadmin_idと管理者のidが一致していれば良い
    assert_redirected_to admin_users_url
    assert_equal admin_user.id, session[:admin_user_id]
  end

  test "#destroy ログアウトができる" do
    # まずはログインしてセッションを作成
    admin_user = AdminUser.create!(email: "test_admin_user@example.com", password: "12345678")
    login_as(admin_user)
    assert_equal admin_user.id, session[:admin_user_id]

    delete admin_login_url

    # ログイン画面にリダイレクトし、セッションがないことを確認
    assert_redirected_to new_admin_login_url
    assert_nil session[:admin_user_id]
  end
end
