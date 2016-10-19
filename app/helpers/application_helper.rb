module ApplicationHelper
  def in_main_app?
    if (devise_controller? || params["controller"] == "landing") && action_name != "edit"
      false
    else
      true
    end
  end

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
