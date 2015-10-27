require 'curb'
require 'nokogiri'
require_relative '../mongo_client'
require_relative 'metro'

class Flat
  attr_reader :url
  attr_reader :row

  def initialize(url, force = false)
    @force = force

    @url = normalize_url(url)

    flat_row
  end

  private

  def flat_row
    if @force || $mongo_client[:flats].find(url: url).first.nil?
      client = Curl::Easy.new(url)
      client.follow_location = true
      client.perform

      @content = client.body.force_encoding('utf-8')

      if @content.size.zero?
        return nil
      end

      if @force
        $mongo_client[:flats].find(url: url).delete_one
      end

      attributes = {
        url: url,
        content: @content,
        provider: provider
      }.merge(parsed_attributes)

      $mongo_client[:flats].insert_one(attributes)
    end

    @row = $mongo_client[:flats].find(url: url).first
  end
end
