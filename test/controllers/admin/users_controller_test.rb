require 'test_helper'

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    # createで使用するparameter
    def valid_create_params
      {
        user: {
          full_name: 'テストユーザー',
          full_name_kana: 'テスト ユーザー',
          gender: 'male',
          email: 'new@example.com',
          home_phone: '99999999999',
          mobile_phone: '88888888888',
          postal_code: '7776666',
          prefecture: '北海道',
          city: '札幌市',
          town: '中央区北',
          address_block: '１条西２丁目１',
          building: '',
          birth_date: '2020-06-17',
          department_id: departments(:test_department).id,
          skill_ids: ['1'],
          image: fixture_file_upload(Rails.root.join('test/fixtures/files/test.png'), 'image/png')
        }
      }
    end

    # updateで使用するparameter
    def valid_update_params
      {
        user: {
          full_name: 'updated_user',
          full_name_kana: 'アップデート ユーザー',
          gender: 'male',
          email: 'new@example.com',
          home_phone: '99999999999',
          mobile_phone: '88888888888',
          postal_code: '7776666',
          prefecture: '北海道',
          city: '札幌市',
          town: '中央区北',
          address_block: '１条西２丁目１',
          building: '',
          birth_date: '2020-06-17',
          department_id: departments(:test_department).id,
          skill_ids: ['2']
        }
      }
    end

    test '#index でユーザー一覧ページが表示される' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # ユーザー一覧ページにGETリクエストを送信
      # admin_users_urlメソッドを使用して、ユーザー一覧ページのURLを取得
      get admin_users_url

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#index 未ログイン時にはユーザー一覧ページにアクセスできない' do
      get admin_users_url
      assert_response :found
    end

    test '#index 名前でLIKE検索ができる' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # full_nameで"三上"が部分一致で取得できるユーザー2名でテストを行う。
      shigeo = users(:shigeo) # "三上 茂雄"
      hana = users(:hana) # "三上 葉奈"
      takeo = users(:takeo) # "三井 威雄"

      # 管理者画面のユーザー一覧ページで検索を行う
      get admin_users_url, params: { name: '三上' }

      # レスポンスが200番台であることを確認
      assert_response :success

      # 検索後のページに<li>三上 茂雄</li>と<li>三上 葉奈</li>が存在しており、
      # <li>三井 威雄</li>が存在していないことを確認
      assert_select 'li', shigeo.full_name
      assert_select 'li', hana.full_name
      assert_not_select 'li', takeo.full_name
    end

    test '#index 都道府県絞り込みができる' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # 住所の都道府県情報で,"福岡県"で取得できるユーザー1名でテストを行う。
      shigeo = users(:shigeo) # "福岡県"
      hana = users(:hana) # "栃木県"
      takeo = users(:takeo) # "大分県"

      # 管理者画面のユーザー一覧ページで検索を行う
      get admin_users_url, params: { pref: '福岡県' }

      # レスポンスが200番台であることを確認
      assert_response :success

      # 検索後のページに<li>三上 茂雄</li>が存在しており、
      # <li>三上 葉奈</li>とli>三井 威雄</li>が存在していないことを確認
      assert_select 'li', shigeo.full_name
      assert_not_select 'li', hana.full_name
      assert_not_select 'li', takeo.full_name
    end

    test '#index 誕生日が古→新に並ぶ' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # フィクスチャ: hana(一番古い) -> shigeo -> takeo(一番新しい)
      shigeo = users(:shigeo) # 1924-02-27
      hana = users(:hana) # 1924-01-17
      takeo = users(:takeo) # 1925-01-13

      get admin_users_url, params: { birth: 'asc' }
      assert_response :success

      # response => ActionDispatch::TestResponse
      body = response.parsed_body

      # 各名前の出現位置（インデックス）を比較して順序を確認
      idx_shigeo = body.index(shigeo.full_name)
      idx_hana = body.index(hana.full_name)
      idx_takeo = body.index(takeo.full_name)

      assert idx_hana < idx_shigeo && idx_shigeo < idx_takeo
    end

    test '#index ユーザーが10件だけ描画される' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # 表示させる用のユーザーを11人作成
      11.times do |i|
        # バリデーションをスキップして保存したいのでsaveメソッドで
        User.new(full_name: "テスト#{i}").save(validate: false)
      end

      get admin_users_url, params: { per: '10' }
      assert_response :success

      assert_select 'li', count: 10
    end

    test '#show ユーザー詳細ページが表示される' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # usersメソッドを使用して、テスト用のユーザーを取得
      user = users(:test_user)

      # 作成したユーザーの詳細ページにGETリクエストを送信
      # user_urlメソッドを使用して、ユーザーの詳細ページのURLを取得
      get admin_user_url(user)

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#new 新規作成フォームが表示される' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # ユーザー新規作成ページにGETリクエストを送信
      get new_admin_user_url

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#create でユーザーとユーザースキルが1件ずつ増える + 画像を作成できる' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # POSTリクエスト送信後にユーザーとユーザースキルが作成されたかどうかを確認する
      # assert_differenceメソッドを使用して、UserモデルとUserSkillモデルのレコード数が1増えることを確認
      assert_difference(['User.count', 'UserSkill.count']) do
        post admin_users_url, params: valid_create_params
      end
      # Userカラムに画像データが入っていることを確認
      user = User.order(:created_at).last
      assert_not_nil user.image

      # レスポンスがリダイレクトであることを確認
      assert_response :redirect
    end

    test '#create で無効パラメータの場合は作成されない' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # POSTリクエスト送信後にユーザーが作成されないことを確認
      assert_no_difference('User.count') do
        post admin_users_url, params: { user: { full_name: '' } }
      end
      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity
    end

    test '#create で不正なMIMEタイプのファイルの場合はユーザーが作成されない' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # MIMEタイプが"text/plain"のファイルをPOSTリクエストで送信する
      params = valid_create_params
      params[:user][:image] = fixture_file_upload(Rails.root.join('test/fixtures/files/invalid_type.txt'), 'text/plain')

      # POSTリクエスト送信後にユーザーが作成されないことを確認
      assert_no_difference('User.count') do
        post admin_users_url, params: params
      end

      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity
    end

    test '#create でファイルサイズが64KB以上のファイルをアップロードした場合はユーザーが作成されない' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # MIMEタイプが"text/plain"のファイルをPOSTリクエストで送信する
      params = valid_create_params
      params[:user][:image] = fixture_file_upload(Rails.root.join('test/fixtures/files/too_big.png'), 'image/png')

      # POSTリクエスト送信後にユーザーが作成されないことを確認
      assert_no_difference('User.count') do
        post admin_users_url, params: params
      end

      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity
    end

    test '#edit 編集フォームが表示される' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # usersメソッドを使用して、テスト用のユーザーを取得
      user = users(:test_user)

      # 作成したユーザーの編集ページにGETリクエストを送信
      get edit_admin_user_url(user)

      # レスポンスが200番台であることを確認
      assert_response :success
    end

    test '#update ユーザー情報とユーザースキルを更新できる' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # usersメソッドを使用して、テスト用のユーザーを取得
      user = users(:test_user)

      # 更新するパラメータを定義
      params = valid_update_params
      # PATCHリクエストを送信してユーザー情報とユーザースキル情報を更新
      # assert_no_differenceメソッドを使用して、UserモデルとUserSkillモデルのレコード数が変わらないことを確認
      assert_no_difference('User.count') do
        patch admin_user_url(user), params: params
      end

      # レスポンスがリダイレクトであることを確認
      assert_response :redirect

      # 更新後のユーザー情報を取得
      user.reload
      # ユーザー名が更新されていることを確認
      assert_equal 'updated_user', user.full_name
    end

    test '#update 無効パラメータの場合は更新されない' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # usersメソッドを使用して、テスト用のユーザーを取得
      user = users(:test_user)

      # PATCHリクエストを送信してユーザー情報を更新
      # assert_no_differenceメソッドを使用して、Userモデルのレコード数が変わらないことを確認
      assert_no_difference('User.count') do
        patch admin_user_url(user), params: { user: { full_name: '' } }
      end

      # レスポンスが422番であることを確認
      assert_response :unprocessable_entity

      # 更新後のユーザー情報を取得
      user.reload
      # ユーザー名が更新されていないことを確認
      assert_equal 'test_user', user.full_name
    end

    test '#destroy ユーザーを削除できる' do
      admin_user = AdminUser.create!(email: 'test_admin_user@example.com', password: '12345678')
      login_as(admin_user)
      # usersメソッドを使用して、テスト用のユーザーを取得
      user = users(:test_user)

      # DELETEリクエストを送信してユーザーを削除
      # assert_differenceメソッドを使用して、Userモデルのレコード数が1減ることを確認
      assert_difference('User.count', -1) do
        delete admin_user_url(user)
      end

      # レスポンスがリダイレクトであることを確認
      assert_response :see_other
    end
  end
end
