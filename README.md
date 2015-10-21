# Simple Avito Flats parser

1. `bundle`
2. **start mongo**
3. **start redis**
4. `bundle exec sidekiq -r ./enqueuer.rb`
5. For Sidekiq monitoring `rackup` and open browser at **http://localhost:9292**

### Some useful info (Sidekiq)

* `Sidekiq.redis {|c| puts c.keys('*') }` shows all redis keys
* `Sidekiq.redis {|c| c.del('stat:processed') }` deletes processed jobs stats
* `Sidekiq.redis {|c| c.del('stat:failed') }` deletes failed jobs stats
* `Sidekiq.redis {|c| c.del('retry') }` deletes retries stats
