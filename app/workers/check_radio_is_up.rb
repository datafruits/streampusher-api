class CheckRadioIsUp < ActiveJob::Base
  queue_as :default

  def perform
    Radio.find_each do |radio|
      url = radio.icecast_panel_url
      res = Net::HTTP.get_response(URI("http://is-this-dongle-working.herokuapp.com/?site=#{url.to_s}"))
      if res.body == "yes"
        puts "radio is up"
      elsif res.body == "no"
        AdminMailer.radio_not_reachable radio
      else
        puts "error: #{res.body}"
      end
    end
  end
end
