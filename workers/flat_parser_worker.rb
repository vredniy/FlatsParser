require_relative '../lib/flat'

class FlatParserWorker
  include Sidekiq::Worker

  def perform(url, force = false)
    Flat.new(url, force)
  end
end
