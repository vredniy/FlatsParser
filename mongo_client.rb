require 'mongo'
$mongo_client = Mongo::Client.new([ '127.0.0.1:27017' ], database: 'flats')

flats_indexes = $mongo_client[:flats].indexes
pages_indexes = $mongo_client[:pages].indexes

begin
  unless flats_indexes.to_a.any? { |i| i['unique'] && i['key'] == {'url' => 1.0 } }
    flats_indexes.create_one({ url: 1 }, unique: true)
  end
rescue Mongo::Error::OperationFailure
  flats_indexes.create_one({ url: 1 }, unique: true)
end

begin
  unless pages_indexes.to_a.any? { |i| i['unique'] && i['key'] == {'url' => 1.0 } }
    pages_indexes.create_one({ url: 1 }, unique: true)
  end
rescue Mongo::Error::OperationFailure
  pages_indexes.create_one({ url: 1 }, unique: true)
end
