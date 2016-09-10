jayda = User.find_by(email: "jaydabatl@gmail.com")

tumblr = jayda.social_identities.find_by(provider: "tumblr")
access_token = tumblr.token
access_token_secret = tumblr.token_secret

Tumblr.configure do |config|
  config.consumer_key = ENV['TUMBLR_KEY']
  config.consumer_secret = ENV['TUMBLR_SECRET']
  config.oauth_token = access_token
  config.oauth_token_secret = access_token_secret
end

client = Tumblr::Client.new

jayda.radios.first.default_playlist.playlist_tracks.each do |playlist_track|
  embed_code = "<iframe width=\"100%\" height=\"100\" frameborder=\"no\" scrolling=\"no\" src=\"http://#{playlist_track.track.radio.virtual_host}/tracks/#{playlist_track.track.id}/embed\"></iframe>"
  client.text "dent-radio.tumblr.com", title: playlist_track.track.title, body: embed_code, tags: "podcast", format: "html", date: playlist_track.podcast_published_date
end
