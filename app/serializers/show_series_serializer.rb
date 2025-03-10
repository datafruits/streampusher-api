class ShowSeriesSerializer < ActiveModel::Serializer
  attributes :id, :recurring_interval, :recurring_cadence, :recurring_weekday, :title, :description,
    :image_url, :thumb_image_url, :image_filename, :slug, :start_time, :end_time, :start_date, :end_date,
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
    if object.image.present?
      object.image_url
    end
  end

  def thumb_image_url
    if object.image.present?
      object.thumb_image_url
    end
  end

  def image_filename
    if object.image.present?
      object.image_file_name
    end
  end

end
