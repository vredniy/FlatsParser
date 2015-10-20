require 'mongo'
$mongo_client = Mongo::Client.new([ '127.0.0.1:27017' ], database: 'flats')
