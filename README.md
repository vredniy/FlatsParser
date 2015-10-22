# Simple Avito Flats parser

1. `bundle`
2. `foreman start`
3. `rake parser:enqueue URLS="url1,url2,url3"` to enqueue urls
4. Open browser at **http://localhost:9292** for sidekiq monitoring

### Some useful info (Sidekiq)

* `Sidekiq.redis {|c| puts c.keys('*') }` shows all redis keys
* `Sidekiq.redis {|c| c.del('stat:processed') }` deletes processed jobs stats
* `Sidekiq.redis {|c| c.del('stat:failed') }` deletes failed jobs stats
* `Sidekiq.redis {|c| c.del('retry') }` deletes retries stats
