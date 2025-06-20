require "test_helper"

class DepartmentsControllerTest < ActionDispatch::IntegrationTest
  test "部署一覧ページの表示" do
    # 部署一覧ページにGETリクエストを送信
    get departments_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "部署の作成" do
    # POSTリクエスト送信後に部署が作成されたかどうかを確認する
    assert_difference("Department.count") do
      post departments_url, params: { department: { name: "add_department" } }
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :redirect
  end

  test "無効なパラメータで部署が作成できないこと" do
    # POSTリクエスト送信後に部署が作成されないことを確認する
    assert_no_difference("Department.count") do
      post departments_url, params: { department: { name: "" } }
    end

    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity
  end

  test "部署新規作成ページの表示" do
    # 部署新規作成ページにGETリクエストを送信
    get new_department_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "ユーザー編集ページの表示" do
    # departmentsメソッドを使用して、テスト用の部署を取得
    department = departments(:test_department)

    # 作成した部署の編集ページにGETリクエストを送信
    get edit_department_url(department)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "部署詳細ページの表示" do
    # departmentsメソッドを使用して、テスト用の部署を取得
    department = departments(:test_department)

    # 作成した部署の詳細ページにGETリクエストを送信
    get department_url(department)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

    test "部署情報の更新" do
    # departmentsメソッドを使用して、テスト用の部署を取得
    department = departments(:test_department)

    # PATCHリクエストを送信して部署情報を更新
    # assert_no_differenceメソッドを使用して、Departmentモデルのレコード数が変わらないことを確認
    assert_no_difference("Department.count") do
      patch department_url(department), params: { department: { name: "updated_department" } }
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :redirect

    # 更新後のユーザー情報を取得
    department.reload
    # ユーザー名が更新されていることを確認
    assert_equal "updated_department", department.name
  end

  test "無効なパラメータで部署を更新できないこと" do
    # departmentsメソッドを使用して、テスト用の部署を取得
    department = departments(:test_department)

    # PATCHリクエストを送信して部署情報を更新
    # assert_no_differenceメソッドを使用して、Departmentモデルのレコード数が変わらないことを確認
    assert_no_difference("Department.count") do
      patch department_url(department), params: { department: { name: "" } }
    end

    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity

    # 更新後のユーザー情報を取得
    department.reload
    # 部署名が更新されていないことを確認
    assert_equal "test_department", department.name
  end

  test "部署の削除" do
    # departmentsメソッドを使用して、テスト用の部署を取得
    department = departments(:test_department)

    # DELETEリクエストを送信して部署を削除
    # assert_differenceメソッドを使用して、Departmentモデルのレコード数が1減ることを確認
    assert_difference("Department.count", -1) do
      delete department_url(department)
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :see_other
  end
end
