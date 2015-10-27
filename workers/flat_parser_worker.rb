require_relative '../lib/flat/cian'
require_relative '../lib/flat/avito'


class FlatParserWorker
  include Sidekiq::Worker

  def perform(url, force = false)
    flat = if url[/cian\.ru/]
             Flat::Cian.new(url, force)
           elsif url[/avito\.ru/]
             Flat::Avito.new(url, force)
           end
  end
end
