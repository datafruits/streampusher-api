module ApplicationHelper
  def html_pipeline(text)
    context = {
      :asset_root => "/images/"
    }
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      #HTML::Pipeline::EmojiFilter,
    ], context
    result = pipeline.call(text)
    result[:output].to_s
  end
end
