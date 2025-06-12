require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    # ユーザー一覧ページにGETリクエストを送信
    # users_urlメソッドを使用して、ユーザー一覧ページのURLを取得
    get users_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "should create user" do
    # POSTリクエスト送信後にユーザーが作成されたかどうかを確認する
    # assert_differenceメソッドを使用して、Userモデルのレコード数が1増えることを確認
    assert_difference("User.count") do
      post users_url, params: { user: { name: "test_user" } }
    end
    # レスポンスがリダイレクトであることを確認
    assert_response :redirect
  end

  test "should not create user with invalid params" do
    # POSTリクエスト送信後にユーザーが作成されないことを確認
    assert_no_difference("User.count") do
      post users_url, params: { user: { name: "" } }
    end
    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity
  end

  test "should get new" do
    # ユーザー新規作成ページにGETリクエストを送信
    get new_user_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "should get edit" do
    # create!メソッドを使用してテストユーザーを作成してINSERTする
    user = User.create!(name: "test_user")

    # 作成したユーザーの編集ページにGETリクエストを送信
    get edit_user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "should get show" do
    # createメソッドを使用しテストユーザーを作成してINSERTする
    # データが必ず有効で保存されることを前提にするためにcreate!で保存失敗時に例外を発生させる
    user = User.create!(name: "test_user")

    # 作成したユーザーの詳細ページにGETリクエストを送信
    # user_urlメソッドを使用して、ユーザーの詳細ページのURLを取得
    get user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "should update user" do
    # create!メソッドを使用しテストユーザーを作成してINSERTする
    user = User.create!(name: "test_user")

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

  test "should not update user with invalid params" do
    # create!メソッドを使用してテストユーザーを作成してINSERTする
    user = User.create!(name: "test_user")
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

  test "should destroy user" do
    # create!メソッドを使用してテストユーザーを作成してINSERTする
    user = User.create!(name: "test_user")

    # DELETEリクエストを送信してユーザーを削除
    # assert_differenceメソッドを使用して、Userモデルのレコード数が1減ることを確認
    assert_difference("User.count", -1) do
      delete user_url(user)
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :see_other
  end
end
