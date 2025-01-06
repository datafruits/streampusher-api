require 'csv'

fruits = StreamPusher.redis.hgetall "datafruits:fruits"

file_name = "./tmp/fruits_report.csv"

CSV.open(file_name, "w") do |csv|
  fruits.each do |k,v|
    csv << [k,v]
  end
end
