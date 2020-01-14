class BlogPostImage < ApplicationRecord
  belongs_to :blog_post_body
  before_save :clean_filename

  def cdn_url
    radio_name = blog_post_body.blog_post.radio.container_name
    "https://#{ENV['CLOUDFRONT_URL']}/#{radio_name}/#{s3_filepath}?#{self.updated_at.to_i}"
  end

  def s3_url
    radio_name = blog_post_body.blog_post.radio.container_name
    "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/#{radio_name}/#{image_file_name}?#{self.updated_at.to_i}"
  end

  private
  def s3_filepath
    file_name = URI.decode(self.image_file_name)
    if file_name.include?(ENV["S3_BUCKET"])
      split = file_name.split(ENV["S3_BUCKET"])
      if split.first =~ /s3.amazonaws.com/
        return split.last[1..-1]
      else
        return split.last.split(".s3.amazonaws.com").last[1..-1]
      end
    else
      return file_name
    end
  end

  def clean_filename
    self.image_file_name = self.image_file_name.gsub /[^\w.-]/i, ''
  end
end
