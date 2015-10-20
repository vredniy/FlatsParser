# Simple Avito Flats parser

1. `bundle`
2. **start mongo**
3. **start redis**
4. `bundle exec sidekiq -r ./enqueuer.rb`
5. For Sidekiq monitoring `rackup` and open browser at **http://localhost:9292**

