# frozen_string_literal: true

require 'test_helper'

module Admin
  class DepartmentsControllerTest < ActionDispatch::IntegrationTest
    test '#idex 部署一覧ページの表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # 部署一覧ページにGETリクエストを送信
      get admin_departments_url

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#index 未ログイン時には部署一覧ページ画面にアクセスできない' do
      get admin_departments_url
      assert_response :found
    end

    test '#show 部署詳細ページの表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # departmentsメソッドを使用して、テスト用の部署を取得
      department = departments(:test_department)

      # 作成した部署の詳細ページにGETリクエストを送信
      get admin_department_url(department)

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#new 部署新規作成ページの表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # 部署新規作成ページにGETリクエストを送信
      get new_admin_department_url

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#edit 部署編集ページの表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # departmentsメソッドを使用して、テスト用の部署を取得
      department = departments(:test_department)

      # 作成した部署の編集ページにGETリクエストを送信
      get edit_admin_department_url(department)

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#create 部署の作成' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # POSTリクエスト送信後に部署が作成されたかどうかを確認する
      assert_difference('Department.count') do
        post admin_departments_url, params: { department: { name: 'add_department' } }
      end

      # レスポンスがリダイレクトであることを確認
      assert_response :redirect
    end

    test '#create 無効なパラメータで部署が作成できないこと' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # POSTリクエスト送信後に部署が作成されないことを確認する
      assert_no_difference('Department.count') do
        post admin_departments_url, params: { department: { name: '' } }
      end

      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity
    end

    test '#update 部署情報の更新' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # departmentsメソッドを使用して、テスト用の部署を取得
      department = departments(:test_department)

      # PATCHリクエストを送信して部署情報を更新
      # assert_no_differenceメソッドを使用して、Departmentモデルのレコード数が変わらないことを確認
      assert_no_difference('Department.count') do
        patch admin_department_url(department), params: { department: { name: 'updated_department' } }
      end

      # レスポンスがリダイレクトであることを確認
      assert_response :redirect

      # 更新後のユーザー情報を取得
      department.reload
      # ユーザー名が更新されていることを確認
      assert_equal 'updated_department', department.name
    end

    test '#update 無効なパラメータで部署を更新できないこと' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # departmentsメソッドを使用して、テスト用の部署を取得
      department = departments(:test_department)

      # PATCHリクエストを送信して部署情報を更新
      # assert_no_differenceメソッドを使用して、Departmentモデルのレコード数が変わらないことを確認
      assert_no_difference('Department.count') do
        patch admin_department_url(department), params: { department: { name: '' } }
      end

      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity

      # 更新後のユーザー情報を取得
      department.reload
      # 部署名が更新されていないことを確認
      assert_equal 'test_department', department.name
    end

    test '#destroy 部署の削除' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # departmentsメソッドを使用して、テスト用の部署を取得
      department = departments(:test_department)

      # DELETEリクエストを送信して部署を削除
      # assert_differenceメソッドを使用して、Departmentモデルのレコード数が1減ることを確認
      assert_difference('Department.count', -1) do
        delete admin_department_url(department)
      end

      # レスポンスがリダイレクトであることを確認
      assert_response :see_other
    end
  end
end
