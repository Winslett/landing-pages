Split.redis = Redis.current
Split.configure do |config|
  config.allow_multiple_experiments = true
  config.db_failover = true
end
