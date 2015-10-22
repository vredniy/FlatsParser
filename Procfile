mongo: mongod --config /usr/local/etc/mongod.conf
redis: redis-server /usr/local/etc/redis.conf
sidekiq: bundle exec sidekiq -r ./workers/page_parser_worker.rb
sidekiq-monitor: rackup
