require_relative '../flat'

class Flat::Cian < Flat
  def provider
    'Cian'
  end

  def normalize_url(url)
    url
  end

  def parsed_attributes
    @doc = Nokogiri::HTML(@content)

    rooms = @doc.css('.object_descr_title')[0].text.strip.to_i
    square = @doc.css("tr > th:contains('Общая площадь:')")[0].parent.css('td').text.strip.to_f
    floor, house_floors = @doc.css("tr > th:contains('Этаж:')")[0]
      .parent.css('td').text.strip.split('/').map {|i| i.gsub(/\D/, '').to_i }

    coord_str = @doc.css('.object_descr_map_static > input')[0][:value]
    uri = Hash[URI.decode_www_form(coord_str)]
    lat, lon, _ = uri['pt'].split(',')

    address = @doc.css('h1.object_descr_addr > a').map &:text

    district = nil
    region = nil

    if address[0] == 'Московская область'
      region, district, city, street, house = address
    elsif address[0] == 'Москва'
      city, district, street, house = address
    else
      puts address.join '::'
      raise 'Wrong address'
    end

    metro_and_distance_by_coordinates = Metro.new(lat, lon).closest_station

    street_house = "#{street} #{house}"

    {
      provider: provider,
      price: @doc.xpath('//div[@class="object_descr_price"]/text()').text.strip.gsub(/\D/, '').to_i,
      rooms: rooms.to_i,
      square: square.to_f,
      floor: floor,
      house_floors: house_floors,
      coord_lat: lat,
      coord_lon: lon,
      region: region,
      city: city,
      street_house: street_house,
      metro_by_coordinates: metro_and_distance_by_coordinates[0],
      metro_distance_by_coordinates: metro_and_distance_by_coordinates[1]
    }
  end
end
