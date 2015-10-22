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

  desc 'Export all flats to .csv'
  task :export do
    db = ENV['DB'] || 'flats'
    collection = ENV['COLLECTION'] || 'flats'
    output = ENV['OUTPUT'] || "data/export.csv"
    fields = ENV['FIELDS'] || %w(
                                url price rooms square floor house_floors coord_lat
                                coord_lon region city street_house metro_by_site metro_distance_by_site
                                metro_by_coordinates metro_distance_by_coordinates
    ).join(',')
    type = ENV['TYPE'] || 'csv'

    command = "mongoexport --db #{db} --collection #{collection} --out #{output} --fields #{fields} --type #{type}"
    system command
  end
end
