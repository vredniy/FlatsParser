require 'csv'

urls = CSV.read('data/variants.csv', col_sep: ';').map do |row|
  row[1]
end.join('&&&')

system "rake enqueue URLS=\"#{urls}\""
