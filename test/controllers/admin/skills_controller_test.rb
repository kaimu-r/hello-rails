require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  test "スキル一覧画面の表示" do
    # スキル一覧画面ページにGETリクエストを送信
    # admin_skills_urlメソッドを使用して、スキル一覧画面ページのURLを取得
    get admin_skills_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "スキルの作成" do
    # POSTリクエスト送信後にスキルが作成されたかどうかを確認する
    # assert_differenceメソッドを使用して、skillモデルのレコード数が1増えることを確認
    assert_difference("Skill.count") do
      post admin_skills_url, params: { skill: { name: "create_skill" } }
    end
    # レスポンスがリダイレクトであることを確認
    assert_response :redirect
  end

  test "無効なパラメータでスキルを作成できないこと" do
    # POSTリクエスト送信後にスキルが作成されないことを確認
    assert_no_difference("Skill.count") do
      post admin_skills_url, params: { skill: { name: "" } }
    end
    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity
  end

  test "スキル新規作成ページの表示" do
    # スキル新規作成ページにGETリクエストを送信
    get new_admin_skill_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "スキル編集ページの表示" do
    # skillsメソッドを使用して、テスト用のスキルを取得
    skill = skills(:test_skill)

    # 作成したスキルの編集ページにGETリクエストを送信
    get edit_admin_skill_url(skill)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "スキル詳細ページの表示" do
    # skillsメソッドを使用して、テスト用のスキルを取得
    skill = skills(:test_skill)

    # 作成したスキルの詳細ページにGETリクエストを送信
    # admin_skill_urlメソッドを使用して、スキルの詳細ページのURLを取得
    get admin_skill_url(skill)

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test "スキル情報の更新" do
    # skillsメソッドを使用して、テスト用のスキルを取得
    skill = skills(:test_skill)

    # PATCHリクエストを送信してスキル情報を更新
    # assert_no_differenceメソッドを使用して、skillモデルのレコード数が変わらないことを確認
    assert_no_difference("Skill.count") do
      patch admin_skill_url(skill), params: { skill: { name: "updated_skill" } }
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :redirect

    # 更新後のスキル情報を取得
    skill.reload
    # スキル名が更新されていることを確認
    assert_equal "updated_skill", skill.name
  end

  test "無効なパラメータでスキルを更新できないこと" do
    # skillsメソッドを使用して、テスト用のスキルを取得
    skill = skills(:test_skill)

    # PATCHリクエストを送信してスキル情報を更新
    # assert_no_differenceメソッドを使用して、skillモデルのレコード数が変わらないことを確認
    assert_no_difference("Skill.count") do
      patch admin_skill_url(skill), params: { skill: { name: "" } }
    end

    # レスポンスが422番であることを確認
    assert_response :unprocessable_entity

    # 更新後のスキル情報を取得
    skill.reload
    # スキル名が更新されていないことを確認
    assert_equal "test_skill", skill.name
  end

  test "スキルの削除" do
    # skillsメソッドを使用して、テスト用のスキルを取得
    skill = skills(:test_skill)

    # DELETEリクエストを送信してスキルを削除
    # assert_differenceメソッドを使用して、skillモデルのレコード数が1減ることを確認
    assert_difference("Skill.count", -1) do
      delete admin_skill_url(skill)
    end

    # レスポンスがリダイレクトであることを確認
    assert_response :see_other
  end
end
