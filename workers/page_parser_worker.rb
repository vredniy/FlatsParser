require_relative '../lib/site'

class PageParserWorker
  include Sidekiq::Worker

  def perform(url)
    Site.new(url)
  end
end
