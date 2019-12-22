class BlogPostBodySerializer < ActiveModel::Serializer
  attributes :id, :body, :title, :language, :rendered_body

  def rendered_body
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
    ]
    pipeline.call(object.body)[:output].to_s
  end
end
