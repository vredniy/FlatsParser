require 'csv'

class Metro
  def initialize(flat_lat, flat_lon)
    @flat_lat = flat_lat
    @flat_lon = flat_lon

    @metro_list_with_coordinates = CSV.read('data/metro_coordinates.csv')
  end

  def closest_station
    @metro_list_with_coordinates.map do |metro_with_coordinate|
      [
        metro_with_coordinate[0],
        distance(
          make_coordinate(metro_with_coordinate[1].to_f, metro_with_coordinate[2].to_f),
          make_coordinate(@flat_lat.to_f, @flat_lon.to_f)
        )
      ]
    end.sort_by { |r| r[1] }.first
  end

  private

  def distance(loc1, loc2)
    r = 6371 * 1000
    d_lat = (loc2['lat'] - loc1['lat']) * (Math::PI / 180)
    d_lon = (loc2['lon'] - loc1['lon']) * (Math::PI / 180)
    a = Math::sin(d_lat / 2) * Math::sin(d_lat / 2) + Math::cos(loc1['lat'] * (Math::PI / 180)) * Math::cos(loc2['lat'] * (Math::PI / 180)) * Math::sin(d_lon / 2) * Math::sin(d_lon / 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))
    r * c
  end

  def make_coordinate(latitude, longitude)
    { 'lat' => latitude, 'lon' => longitude }
  end
end
