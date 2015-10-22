require 'curb'
require 'nokogiri'
require_relative '../mongo_client'
require_relative 'metro'

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

    metro_distance = [nil, nil]

    if @doc.css('.metro-list').size != 0
      distance = 0

      closest_metro = @doc.css('.metro-list > .metro-item').sort_by do |m|
        t = m.css('.c-2').text

        distance = if t[/км/]
                     t.to_f * 1000
                   else
                     t.to_f
                   end
      end.first

      metro_distance = [
        closest_metro.children[2].text.strip,
        distance
      ]
    end

    lat = coordinates.attributes['data-map-lat'].text
    lon = coordinates.attributes['data-map-lon'].text

    metro_and_distance_by_coordinates = Metro.new(lat, lon).closest_station

    street_house = @doc.css('#toggle_map')[0].text

    {
      price: @doc.css('.p_i_price')[0].text.gsub(/[^\d]/, '').to_i,
      rooms: rooms.to_i,
      square: square.to_f,
      floor: floor,
      house_floors: house_floors,
      coord_lat: lat,
      coord_lon: lon,
      region: region,
      city: city,
      street_house: street_house,
      metro_by_site: metro_distance[0],
      metro_distance_by_site: metro_distance[1],
      metro_by_coordinates: metro_and_distance_by_coordinates[0],
      metro_distance_by_coordinates: metro_and_distance_by_coordinates[1]
    }
  end
end
