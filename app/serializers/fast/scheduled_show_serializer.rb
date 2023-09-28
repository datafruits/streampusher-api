class Fast::ScheduledShowSerializer
  include JSONAPI::Serializer

  has_many :tracks # , serializer: TrackSerializer

  attributes :id, :start, :end, :title, :image_url, :thumb_image_url, :description,
    :slug, :recurring_interval, :is_guest, :guest, :image, :image_filename

  attribute :hosted_by do |object|
    if object.performers.any?
      object.performers.first.username
    end
  end

  attribute :image_url do |object|
    if object.image.present?
      CGI.unescape(object.image_url)
    end
  end

  attribute :thumb_image_url do |object|
    if object.image.present?
      CGI.unescape(object.thumb_image_url)
    end
  end

  attribute :image do |object|
    if object.image.present?
      {
        basename: object.image_file_name,
        attachment: "images",
        updated_at: object.image.updated_at
      }
    end
  end

  attribute :image_filename do |object|
    if object.image.present?
      object.image_file_name
    end
  end

  attribute :show_series_slug do |object|
    object.show_series.slug
  end
end
