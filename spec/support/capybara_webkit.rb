Capybara::Webkit.configure do |config|
  config.allow_url "js.stripe.com"
  config.allow_url "s3.amazonaws.com"
  config.allow_url "datafruits.streampusher.com"
end
