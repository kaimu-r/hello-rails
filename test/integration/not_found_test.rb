require "test_helper"

class NotFoundTest < ActionDispatch::IntegrationTest
  test "#show: 存在しないIDで404と本文が返る" do
    get user_url(999999)

    assert_response :not_found
    assert_select "h1", text: "お探しのページは見つかりませんでした"
  end
end
