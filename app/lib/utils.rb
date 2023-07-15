require 'net/http'
require 'tempfile'
require 'uri'

module Utils
  def download_tempfile(url)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      resp = http.get(uri.path)
      file = Tempfile.new([File.basename(url, File.extname(url)), File.extname(url).split("?").first])
      file.binmode
      file.write(resp.body)
      file.flush
      file
    end
  end
end
