require_relative '../lib/site'
require_relative 'flat_parser_worker'

class PageParserWorker
  include Sidekiq::Worker

  def perform(url, force = true)
    Site.new(url, force).urls_to_flats.each do |flat_url|
      FlatParserWorker.perform_async(flat_url)
    end
  end
end
