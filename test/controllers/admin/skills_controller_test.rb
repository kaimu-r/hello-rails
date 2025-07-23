# frozen_string_literal: true

require 'test_helper'

module Admin
  class SkillsControllerTest < ActionDispatch::IntegrationTest
    test '#index スキル一覧画面の表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # スキル一覧画面ページにGETリクエストを送信
      # admin_skills_urlメソッドを使用して、スキル一覧画面ページのURLを取得
      get admin_skills_url

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#index 未ログイン時にはスキル一覧画面にアクセスできない' do
      get admin_skills_url
      assert_response :found
    end

    test '#show スキル詳細ページの表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # skillsメソッドを使用して、テスト用のスキルを取得
      skill = skills(:test_skill)

      # 作成したスキルの詳細ページにGETリクエストを送信
      # admin_skill_urlメソッドを使用して、スキルの詳細ページのURLを取得
      get admin_skill_url(skill)

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#new スキル新規作成ページの表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # スキル新規作成ページにGETリクエストを送信
      get new_admin_skill_url

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#edit スキル編集ページの表示' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # skillsメソッドを使用して、テスト用のスキルを取得
      skill = skills(:test_skill)

      # 作成したスキルの編集ページにGETリクエストを送信
      get edit_admin_skill_url(skill)

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#create スキルの作成' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # POSTリクエスト送信後にスキルが作成されたかどうかを確認する
      # assert_differenceメソッドを使用して、skillモデルのレコード数が1増えることを確認
      assert_difference('Skill.count') do
        post admin_skills_url, params: { skill: { name: 'create_skill' } }
      end
      # レスポンスがリダイレクトであることを確認
      assert_response :redirect
    end

    test '#create 無効なパラメータでスキルを作成できないこと' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # POSTリクエスト送信後にスキルが作成されないことを確認
      assert_no_difference('Skill.count') do
        post admin_skills_url, params: { skill: { name: '' } }
      end
      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity
    end

    test '#update スキル情報の更新' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # skillsメソッドを使用して、テスト用のスキルを取得
      skill = skills(:test_skill)

      # PATCHリクエストを送信してスキル情報を更新
      # assert_no_differenceメソッドを使用して、skillモデルのレコード数が変わらないことを確認
      assert_no_difference('Skill.count') do
        patch admin_skill_url(skill), params: { skill: { name: 'updated_skill' } }
      end

      # レスポンスがリダイレクトであることを確認
      assert_response :redirect

      # 更新後のスキル情報を取得
      skill.reload
      # スキル名が更新されていることを確認
      assert_equal 'updated_skill', skill.name
    end

    test '#update 無効なパラメータでスキルを更新できないこと' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # skillsメソッドを使用して、テスト用のスキルを取得
      skill = skills(:test_skill)

      # PATCHリクエストを送信してスキル情報を更新
      # assert_no_differenceメソッドを使用して、skillモデルのレコード数が変わらないことを確認
      assert_no_difference('Skill.count') do
        patch admin_skill_url(skill), params: { skill: { name: '' } }
      end

      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity

      # 更新後のスキル情報を取得
      skill.reload
      # スキル名が更新されていないことを確認
      assert_equal 'test_skill', skill.name
    end

    test '#destroy スキルの削除' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # skillsメソッドを使用して、テスト用のスキルを取得
      skill = skills(:test_skill)

      # DELETEリクエストを送信してスキルを削除
      # assert_differenceメソッドを使用して、skillモデルのレコード数が1減ることを確認
      assert_difference('Skill.count', -1) do
        delete admin_skill_url(skill)
      end

      # レスポンスがリダイレクトであることを確認
      assert_response :see_other
    end
  end
end
