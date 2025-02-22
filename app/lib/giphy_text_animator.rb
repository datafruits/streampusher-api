require 'net/http'
require 'uri'
require 'json'

class GiphyTextAnimator
  BASE_URL = "https://api.giphy.com/v1/text/animate"
  API_KEY = "OJAyf3JHblNAu9hHhmccbPrH4wCN0pJQ"

  def self.animate_text(username, message="subscribed to the patreon", limit=50)
    uri = URI(BASE_URL)
    params = {
      api_key: API_KEY,
      m: "#{username} #{message}",
      limit: limit
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      results = JSON.parse(response.body)["data"]
      return results.sample["images"]["original"]["url"] if results.any?
      { error: "No results found" }
    else
      { error: "Failed to fetch animated text", status: response.code }
    end
  end
end
