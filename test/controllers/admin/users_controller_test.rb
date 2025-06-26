require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # createで使用するparameter
  def valid_create_params
    {
      user: {
        full_name: "テストユーザー",
        full_name_kana: "テスト ユーザー",
        gender: "male",
        email: "new@example.com",
        home_phone: "99999999999",
        mobile_phone: "88888888888",
        postal_code: "7776666",
        prefecture: "北海道",
        city: "札幌市",
        town: "中央区北",
        address_block: "１条西２丁目１",
        building: "",
        birth_date: "2020-06-17",
        department_id: departments(:test_department).id,
        skill_ids: ["1"]
      }
    }
  end

  # updateで使用するparameter
  def valid_update_params
    {
      user: {
        full_name: "updated_user",
        full_name_kana: "アップデート ユーザー",
        gender: "male",
        email: "new@example.com",
        home_phone: "99999999999",
        mobile_phone: "88888888888",
        postal_code: "7776666",
        prefecture: "北海道",
        city: "札幌市",
        town: "中央区北",
        address_block: "１条西２丁目１",
        building: "",
        birth_date: "2020-06-17",
        department_id: departments(:test_department).id,
        skill_ids: ["2"]
      }
    }
  end

  test "GET /users でユーザー一覧ページが表示される" do
    # ユーザー一覧ページにGETリクエストを送信
    # admin_users_urlメソッドを使用して、ユーザー一覧ページのURLを取得
    get admin_users_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "POST /users でユーザーとユーザースキルが1件ずつ増える" do
    # parameterを定義
    params = valid_create_params
    # POSTリクエスト送信後にユーザーとユーザースキルが作成されたかどうかを確認する
    # assert_differenceメソッドを使用して、UserモデルとUserSkillモデルのレコード数が1増えることを確認
    assert_difference(["User.count", "UserSkill.count"]) do
      post admin_users_url, params: params
    end
    # レスポンスがリダイレクトであることを確認
    assert_response :redirect
  end

  test "POST /users で無効パラメータの場合は作成されない" do
    # POSTリクエスト送信後にユーザーが作成されないことを確認
    assert_no_difference("User.count") do
      post admin_users_url, params: { user: { full_name: "" } }
    end
    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity
  end

  test "GET /users/new で新規作成フォームが表示される" do
    # ユーザー新規作成ページにGETリクエストを送信
    get new_admin_user_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "GET /users/:id/edit で編集フォームが表示される" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:test_user)

    # 作成したユーザーの編集ページにGETリクエストを送信
    get edit_admin_user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "GET /users/:id でユーザー詳細ページが表示される" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:test_user)

    # 作成したユーザーの詳細ページにGETリクエストを送信
    # user_urlメソッドを使用して、ユーザーの詳細ページのURLを取得
    get admin_user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "PATCH /users/:id でユーザー情報とユーザースキルを更新できる" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:test_user)

    # 更新するパラメータを定義
    params = valid_update_params
    # PATCHリクエストを送信してユーザー情報とユーザースキル情報を更新
    # assert_no_differenceメソッドを使用して、UserモデルとUserSkillモデルのレコード数が変わらないことを確認
    assert_no_difference("User.count") do
      patch admin_user_url(user), params: params
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :redirect

    # 更新後のユーザー情報を取得
    user.reload
    # ユーザー名が更新されていることを確認
    assert_equal "updated_user", user.full_name
  end

  test "PATCH /users/:id で無効パラメータの場合は更新されない" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:test_user)

    # PATCHリクエストを送信してユーザー情報を更新
    # assert_no_differenceメソッドを使用して、Userモデルのレコード数が変わらないことを確認
    assert_no_difference("User.count") do
      patch admin_user_url(user), params: { user: { full_name: "" } }
    end

    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity

    # 更新後のユーザー情報を取得
    user.reload
    # ユーザー名が更新されていないことを確認
    assert_equal "test_user", user.full_name
  end

  test "DELETE /users/:id でユーザーが 1 件減る" do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:test_user)

    # DELETEリクエストを送信してユーザーを削除
    # assert_differenceメソッドを使用して、Userモデルのレコード数が1減ることを確認
    assert_difference("User.count", -1) do
      delete admin_user_url(user)
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :see_other
  end
end
