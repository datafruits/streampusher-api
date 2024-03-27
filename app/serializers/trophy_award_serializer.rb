class TrophyAwardSerializer < ActiveModel::Serializer
  attributes :name, :image_url, :model_url

  def name
    object.trophy.name
  end

  def image_url
    if object.trophy.image.present?
      if ::Rails.env != "production"
        ::Rails.application.routes.url_helpers.rails_blob_path(object.trophy.image, only_path: true, disposition: 'attachment')
      else
        object.image.url
      end
    end
  end

  def model_url
    if object.trophy.model.present?
      if ::Rails.env != "production"
        ::Rails.application.routes.url_helpers.rails_blob_path(object.trophy.model, only_path: true, disposition: 'attachment')
      else
        object.model.url
      end
    end
  end
end
