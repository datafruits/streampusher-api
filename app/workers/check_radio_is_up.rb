require 'net/http'
require 'uri'

class CheckRadioIsUp < ActiveJob::Base
  queue_as :default

  def perform
    Radio.each do |radio|
      radio = Radio.find radio_id
      res = Net::HTTP.get_response(URI(radio.icecast_panel_url))
      if res.code.to_i != 200
        # send alert to admin
      else
        puts "radio is up"
      end
    end
  end
end
