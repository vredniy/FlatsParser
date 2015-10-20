require 'curb'
require 'nokogiri'

class Flat
  attr_reader :region, :city, :district, :street_house, :address
  attr_reader :title
  attr_reader :doc

  attr_reader :coordinates
  attr_reader :square, :rooms, :floor, :house_floors

  attr_reader :price

  attr_reader :url

  def initialize(url)
    @url = if url[/http/]
             url
           else
             "https://www.avito.ru#{url}"
           end

    parse
  end

  private

  def parse
    @doc = Nokogiri::HTML(Curl.get(@url).body.force_encoding('utf-8'))

    _address
    # title
    _rooms
    _coordinates
    _price

    self
  end

  def _external_id
  end

  def _price
    @price = @doc.css('.p_i_price')[0].text.gsub(/[^\d]/, '').to_i
  end


  def _rooms
    rooms, square, floors = @doc.css('h1.h1')[0].text.split(',')

    @rooms = rooms.to_i
    @square = square.to_i

    @floor, @house_floors = floors.gsub(/[^\d\/]/, '').split('/').map &:to_i
  end

  def _coordinates
    coordinates = @doc.css('.b-search-map')[0]

    raise 'no coordinates' if coordinates.nil?

    @coordinates = [coordinates.attributes['data-map-lat'].text, coordinates.attributes['data-map-lon'].text]
  end

  # def title
  #   _, @title, _ = @doc.css('title')[0].text.strip.split(' - ')
  # end

  def _address
    result = @doc.css('div#map > span').map &:text

    if result.size == 1 # москва
      @city = result[0]
    elsif result.size == 2
      @region, @city = result
    else
      require 'pry'; binding.pry
      puts result.join '::'
      raise 'wrong address'
    end

    result = @doc.css('#toggle_map')[0].text

    @street_house = result

    # if @house.nil?
    #   require 'pry'; binding.pry
    # end

    # raise 'Street is nil' unless @street
    # raise 'House is nil' unless @house

    @address = {
      region: @region, city: @city, street_house: @street_house
    }
  end
end
