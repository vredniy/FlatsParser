# Simple Avito.ru and Cian.ru Flats parser

1. `bundle`
2. `foreman start`
3. Edit **data/variants.csv**
4. `ruby enqueue.rb` to enqueue urls
5. Open browser at **http://localhost:9292** for sidekiq monitoring
6. `rake export` for export data to csv format (**data/export.csv** file) for further analysis
