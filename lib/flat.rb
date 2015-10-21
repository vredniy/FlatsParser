require 'curb'
require 'nokogiri'
require_relative '../mongo_client'

class Flat
  attr_reader :url
  attr_reader :row

  def initialize(url, force = false)
    @force = force

    @url = if url[/http/]
             url
           else
             "https://www.avito.ru#{url}"
           end

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
        content: @content
      }.merge(parsed_attributes)

      $mongo_client[:flats].insert_one(attributes)
    end

    @row = $mongo_client[:flats].find(url: url).first
  end

  def parsed_attributes
    @doc = Nokogiri::HTML(@content)

    rooms, square, floors = @doc.css('h1.h1')[0].text.split(',')
    @rooms = rooms.to_i
    @square = square.to_i
    floor, house_floors = floors.gsub(/[^\d\/]/, '').split('/').map &:to_i

    coordinates = @doc.css('.b-search-map')[0]

    result = @doc.css('div#map > span').map &:text

    region = nil
    city = nil

    if result.size == 1 # москва
      city = result[0]
    elsif result.size == 2
      region, city = result
    else
      puts result.join '::'
      raise 'wrong address'
    end

    street_house = @doc.css('#toggle_map')[0].text

    {
      price: @doc.css('.p_i_price')[0].text.gsub(/[^\d]/, '').to_i,
      rooms: rooms.to_i,
      square: square.to_f,
      floor: floor,
      house_floors: house_floors,
      coord_lat: coordinates.attributes['data-map-lat'].text,
      coord_lon: coordinates.attributes['data-map-lon'].text,
      region: region,
      city: city,
      street_house: street_house,
    }
  end
end
