# frozen_string_literal: true

Kaminari.configure do |config|
  # 1ページあたりのデフォルト表示件数を20件に設定
  config.default_per_page = 20

  # 1ページあたりの最大の表示件数を100件に指定
  config.max_per_page = 100
end
