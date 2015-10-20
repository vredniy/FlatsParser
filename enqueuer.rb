require 'mongo'
require 'sidekiq'
require_relative 'workers/page_parser_worker'

PageParserWorker.perform_async(
  'https://www.avito.ru/moskovskaya_oblast/kvartiry/prodam?pmax=7000000&pmin=0&user=1&f=549_5697-5698.59_13988b.496_5121b.497_5187b'
)
