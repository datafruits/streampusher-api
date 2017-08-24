class CheckRadioIsUp < ActiveJob::Base
  queue_as :monitor

  def perform
    Radio.enabled.find_each do |radio|
      url = radio.icecast_panel_url
      res = Net::HTTP.get_response(URI(radio.icecast_json))
      json = JSON.parse(res.body)
      server = json.dig("icestats", "source").find{|s| s["server_name"] == "#{radio.container_name}.mp3"}
      if server
        puts "radio is up"
      else
        AdminMailer.radio_not_reachable(radio).deliver_later
        ActiveSupport::Notifications.instrument "radio.down", radio: radio.name
      end
    end
  end
end
