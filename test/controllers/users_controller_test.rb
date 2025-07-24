require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'GET /users でユーザー一覧ページが表示される' do
    # ユーザー一覧ページにGETリクエストを送信
    # admin_users_urlメソッドを使用して、ユーザー一覧ページのURLを取得
    get users_url

    # レスポンスが200番台であることを確認
    assert_response :success
  end

  test 'GET /users?name=value で名前でLIKE検索ができる' do
    # full_nameで"三上"が部分一致で取得できるユーザー2名でテストを行う。
    shigeo = users(:shigeo) # "三上 茂雄"
    hana = users(:hana) # "三上 葉奈"
    takeo = users(:takeo) # "三井 威雄"

    # 管理者画面のユーザー一覧ページで検索を行う
    get users_url, params: { name: '三上' }

    # レスポンスが200番台であることを確認
    assert_response :success

    # 検索後のページに<li>三上 茂雄</li>と<li>三上 葉奈</li>が存在しており、
    # <li>三井 威雄</li>が存在していないことを確認
    assert_select 'li', shigeo.full_name
    assert_select 'li', hana.full_name
    assert_not_select 'li', takeo.full_name
  end

  test 'GET /users?pref=value で都道府県絞り込みができる' do
    # 住所の都道府県情報で,"福岡県"で取得できるユーザー1名でテストを行う。
    shigeo = users(:shigeo) # "福岡県"
    hana = users(:hana) # "栃木県"
    takeo = users(:takeo) # "大分県"

    # 管理者画面のユーザー一覧ページで検索を行う
    get users_url, params: { pref: '福岡県' }

    # レスポンスが200番台であることを確認
    assert_response :success

    # 検索後のページに<li>三上 茂雄</li>が存在しており、
    # <li>三上 葉奈</li>とli>三井 威雄</li>が存在していないことを確認
    assert_select 'li', shigeo.full_name
    assert_not_select 'li', hana.full_name
    assert_not_select 'li', takeo.full_name
  end

  test 'GET /users?birth=asc で誕生日が古→新に並ぶ' do
    # フィクスチャ: hana(一番古い) -> shigeo -> takeo(一番新しい)
    shigeo = users(:shigeo) # 1924-02-27
    hana = users(:hana) # 1924-01-17
    takeo = users(:takeo) # 1925-01-13

    get users_url, params: { birth: 'asc' }
    assert_response :success

    # response => ActionDispatch::TestResponse
    body = response.parsed_body

    # 各名前の出現位置（インデックス）を比較して順序を確認
    idx_shigeo = body.index(shigeo.full_name)
    idx_hana = body.index(hana.full_name)
    idx_takeo = body.index(takeo.full_name)

    assert idx_hana < idx_shigeo && idx_shigeo < idx_takeo
  end

  test 'GET /users?per=10 で ユーザーが10件だけ描画される' do
    # 表示させる用のユーザーを11人作成
    11.times do |i|
      # バリデーションをスキップして保存したいのでsaveメソッドで
      User.new(full_name: "テスト#{i}").save(validate: false)
    end

    get users_url, params: { per: '10' }
    assert_response :success

    assert_select 'li', count: 10
  end

  test 'GET /users/:id でユーザー詳細ページが表示される' do
    # usersメソッドを使用して、テスト用のユーザーを取得
    user = users(:test_user)

    # 作成したユーザーの詳細ページにGETリクエストを送信
    # user_urlメソッドを使用して、ユーザーの詳細ページのURLを取得
    get user_url(user)

    # レスポンスが200番台であることを確認
    assert_response :success
  end
end
