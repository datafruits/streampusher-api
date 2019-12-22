class BlogPostImageSerializer < ActiveModel::Serializer
  attributes :id, :image_file_name, :cdn_url, :s3_url

  def cdn_url
    object.cdn_url
  end

  def s3_url
    object.s3_url
  end
end
