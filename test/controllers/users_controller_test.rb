require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "ユーザー一覧画面の表示" do
    # ユーザー一覧ページにGETリクエストを送信
    # users_urlメソッドを使用して、ユーザー一覧ページのURLを取得
    get users_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "ユーザーの作成" do
    # POSTリクエスト送信後にユーザーが作成されたかどうかを確認する
    # assert_differenceメソッドを使用して、Userモデルのレコード数が1増えることを確認
    assert_difference("User.count") do
      post users_url, params: { user: { name: "test_user" } }
    end
    # レスポンスがリダイレクトであることを確認
    assert_response :redirect
  end

  test "無効なパラメータでユーザーを作成できないこと" do
    # POSTリクエスト送信後にユーザーが作成されないことを確認
    assert_no_difference("User.count") do
      post users_url, params: { user: { name: "" } }
    end
    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity
  end

  test "ユーザー新規作成ページの表示" do
    # ユーザー新規作成ページにGETリクエストを送信
    get new_user_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "ユーザー編集ページの表示" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:one)

    # 作成したユーザーの編集ページにGETリクエストを送信
    get edit_user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "ユーザー詳細ページの表示" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:one)

    # 作成したユーザーの詳細ページにGETリクエストを送信
    # user_urlメソッドを使用して、ユーザーの詳細ページのURLを取得
    get user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "ユーザー情報の更新" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:one)

    # PATCHリクエストを送信してユーザー情報を更新
    # assert_no_differenceメソッドを使用して、Userモデルのレコード数が変わらないことを確認
    assert_no_difference("User.count") do
      patch user_url(user), params: { user: { name: "updated_user" } }
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :redirect

    # 更新後のユーザー情報を取得
    user.reload
    # ユーザー名が更新されていることを確認
    assert_equal "updated_user", user.name
  end

  test "無効なパラメータでユーザーを更新できないこと" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:one)

    # PATCHリクエストを送信してユーザー情報を更新
    # assert_no_differenceメソッドを使用して、Userモデルのレコード数が変わらないことを確認
    assert_no_difference("User.count") do
      patch user_url(user), params: { user: { name: "" } }
    end

    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity

    # 更新後のユーザー情報を取得
    user.reload
    # ユーザー名が更新されていないことを確認
    assert_equal "test_user", user.name
  end

  test "ユーザーの削除" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:one)

    # DELETEリクエストを送信してユーザーを削除
    # assert_differenceメソッドを使用して、Userモデルのレコード数が1減ることを確認
    assert_difference("User.count", -1) do
      delete user_url(user)
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :see_other
  end
end
