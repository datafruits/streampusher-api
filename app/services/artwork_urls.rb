class ArtworkUrls < ActiveSupport::CurrentAttributes
  attribute :cache

  def url(image, rendition)
    return unless image&.attached?

    host = Rails.application.routes.default_url_options[:host]
    if cache && image.attachment.persisted?
      key = [image.attachment.id, rendition, host]
      cache.fetch(key) { cache[key] = build_url(image, rendition, host) }
    else
      build_url(image, rendition, host)
    end
  end

  private

  def build_url(image, rendition, host)
    target = rendition == :original ? image : image.variant(rendition)
    Rails.application.routes.url_helpers.rails_representation_url(target, host: host)
  end
end
