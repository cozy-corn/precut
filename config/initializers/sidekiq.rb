require "sidekiq"
require "sidekiq-cron"

Sidekiq.configure_server do |config|
  # Sidekiqサーバーの設定を開始 ブロック内の設定は、ジョブを実行するサーバー側で適用
  schedule_file = "config/schedule.yml"
  # 定期的に実行するジョブのスケジュールを記述したYAMLファイルのパスを指定
  config.redis = {
    url: ENV["REDIS_URL"],
    # Redisへの接続設定 ENV['REDIS_URL']は環境変数からRedisサーバーのURLを取得
    connect_timeout: 5,
    read_timeout: 5,
    write_timeout: 5
    # 接続、読み取り、書き込みそれぞれに5秒のタイムアウトを設定
  }

  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file)
  # config/schedule.ymlファイルが存在する場合、そのファイルを読み込み、
  # YAMLファイルに記述されたスケジュールに従って定期的なジョブを設定
end

Sidekiq.configure_client do |config|
  # Sidekiqクライアントの設定を開始　この設定は、ジョブをキューに投入する側で適用
  config.redis = {
    url: ENV["REDIS_URL"],
    # Redisへの接続設定 ENV['REDIS_URL']は環境変数からRedisサーバーのURLを取得
    connect_timeout: 5,
    read_timeout: 5,
    write_timeout: 5
    # 接続、読み込み、書き込みそれぞれに5秒のタイムアウトを設定
  }
end
