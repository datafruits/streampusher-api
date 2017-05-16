if ENV['INSECURE_REDIS']
  redis = Redis.new
else
  redis = Redis.new(password: ENV['REDIS_PASSWORD'])
end

Geocoder.configure(
  # Geocoding options
  # timeout: 3,                 # geocoding service timeout (secs)
  # lookup: :google,            # name of geocoding service (symbol)
  ip_lookup: :freegeoip,
  # language: :en,              # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  # api_key: nil,               # API key for geocoding service
  cache: redis,                 # cache object (must respond to #[], #[]=, and #keys)
  cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  always_raise: :all,

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)
