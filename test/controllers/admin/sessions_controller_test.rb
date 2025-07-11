require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#new ログインページにアクセスできる" do
    get new_admin_login_url
    assert_response :success
  end

  test "#create 管理者がログインできる" do
    admin_user = admin_users(:test_admin)

    post admin_login_url, params: { email: admin_user.email }

    # ログイン後に管理画面の従業員一覧画面にリダイレクトし、セッションのadmin_idと管理者のidが一致していれば良い
    assert_redirected_to admin_users_url
    assert_equal admin_user.id, session[:admin_user_id]
  end

  test "#destroy ログアウトができる" do
    admin_user = admin_users(:test_admin)

    # まずはログインしてセッションを作成
    post admin_login_url, params: { email: admin_user.email }
    assert_equal admin_user.id, session[:admin_user_id]

    delete admin_login_url

    # ログイン画面にリダイレクトし、セッションがないことを確認
    assert_redirected_to new_admin_login_url
    assert_nil session[:admin_user_id]
  end

  test "アクセスコントロールをテスト（ログインしていないユーザーがAdminページにアクセスできないかをチェック）" do
    login_path = new_admin_login_url

    # GETのindexアクションのみをチェック
    protected_paths = [
      admin_users_url,
      admin_departments_url,
      admin_skills_url,
    ]

    # 未ログインでアクセスしてログイン画面にリダイレクトできれば良い
    protected_paths.each do |path|
      get path
      assert_redirected_to login_path
    end
  end
end
