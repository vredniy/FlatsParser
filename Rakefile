require 'active_support/core_ext/array/wrap'

namespace :parser do
  desc 'Enqueue Avito search results parsing by url'
  task :enqueue do
    require 'sidekiq'
    require_relative 'workers/page_parser_worker'

    force = ENV['FORCE'] || false
    urls = Array.wrap(ENV['URLS'].split(','))

    urls.each do |url|
      PageParserWorker.perform_async(url, force)

      puts "#{url} enqueued"
    end
  end
end
