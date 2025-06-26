require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "GET /users でユーザー一覧ページが表示される" do
    # ユーザー一覧ページにGETリクエストを送信
    # admin_users_urlメソッドを使用して、ユーザー一覧ページのURLを取得
    get users_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "GET /users/:id でユーザー詳細ページが表示される" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:test_user)

    # 作成したユーザーの詳細ページにGETリクエストを送信
    # user_urlメソッドを使用して、ユーザーの詳細ページのURLを取得
    get user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end
end
