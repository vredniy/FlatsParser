require_relative '../lib/site/cian'
require_relative '../lib/site/avito'
require_relative './flat_parser_worker'

class PageParserWorker
  include Sidekiq::Worker

  def perform(url, force = true)
    site = if url[/cian\.ru/]
             Site::Cian.new(url, force)
           elsif url[/avito\.ru/]
             Site::Avito.new(url, force)
           else
             raise "WRONG URL!  #{url}"
           end

    site.urls_to_flats.each do |flat_url|
      FlatParserWorker.perform_async(flat_url)
    end if site
  end
end
