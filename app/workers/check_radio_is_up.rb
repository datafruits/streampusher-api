require 'net/http'
require 'uri'

class CheckRadioIsUp < ActiveJob::Base
  queue_as :default

  def perform
    Radio.find_each do |radio|
      res = Net::HTTP.get_response(URI(radio.icecast_panel_url))
      if res.code.to_i != 200
        AdminMailer.radio_not_reachable radio
      else
        puts "radio is up"
      end
    end
  end
end
