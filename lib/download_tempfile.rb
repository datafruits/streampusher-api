require 'net/http'
require 'tempfile'
require 'uri'

def download_tempfile(url)
  uri = URI.parse(url)
  Net::HTTP.start(uri.host, uri.port) do |http|
    resp = http.get(uri.path)
    file = Tempfile.new(File.basename(url))
    file.binmode
    file.write(resp.body)
    file.flush
    file
  end
end
