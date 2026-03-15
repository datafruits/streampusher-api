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
    if object.as_image.attached?
      Rails.application.routes.url_helpers.rails_representation_url(
        object.as_image,
        host: Rails.application.routes.default_url_options[:host]
      )
    end
  end

  def thumb_image_url
    if object.as_image.attached?
      begin
        variant = object.as_image.variant(:thumb).processed

        Rails.application.routes.url_helpers.rails_representation_url(
          variant,
          host: Rails.application.routes.default_url_options[:host]
        )
      rescue ActiveStorage::InvariableError => e
        Rails.logger.error("ActiveStorage::InvariableError for show_series id=#{object.id} title=#{object.title}: #{e.message}")
        image_url
      end
    end
  end
end
