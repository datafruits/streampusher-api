class BlogPostBodySerializer < ActiveModel::Serializer
  attributes :id, :body, :title, :language, :rendered_body
  has_many :blog_post_images, embed: :ids, key: :blog_post_images, embed_in_root: true

  def rendered_body
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
    ]
    pipeline.call(object.body)[:output].to_s
  end
end
