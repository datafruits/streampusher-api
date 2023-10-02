class Fast::TrackSerializer
  include JSONAPI::Serializer

  attributes :cdn_url

  def cdn_url
    object.cdn_url
  end
end
