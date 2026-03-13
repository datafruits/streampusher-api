class ShowSeriesSerializer < ActiveModel::Serializer
  attributes :id, :recurring_interval, :recurring_cadence, :recurring_weekday, :title, :description,
    :image_url, :thumb_image_url, :slug, :start_time, :end_time, :start_date, :end_date,
    :status
  has_many :labels, embed: :ids, key: :labels, embed_in_root: true, each_serializer: LabelSerializer
  has_many :users, embed: :ids, key: :users, embed_in_root: true, each_serializer: DjSerializer

  def id
    object.slug
  end

  def users
    object.users
  end

  def labels
    object.labels
  end

  def image_url
    if object.as_image.present?
      if ::Rails.env != "production"
        path = ::Rails.application.routes.url_helpers.rails_blob_path(object.as_image, only_path: true, disposition: 'attachment')
        "http://localhost:3000#{path}"
      else
        object.as_image.url
      end
    end
  end

  def thumb_image_url
    if object.as_image.present?
      variant = object.as_image.variant(:thumb).processed

      if ::Rails.env != "production"
        Rails.application.routes.url_helpers.rails_representation_url(
          variant,
          host: "http://localhost:3000"
        )
      else
        variant.url
      end
    end
  end
end
