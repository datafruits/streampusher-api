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
    sanitize(result[:output].to_s)
  end

  # https://gist.github.com/mrreynolds/4fc71c8d09646567111f
  # Acts as a thin wrapper for image_tag and generates an srcset attribute for regular image tags
  # for usage with responsive images polyfills like picturefill.js, supports asset pipeline path helpers.
  #
  # image_set_tag 'pic_1980.jpg', { 'pic_640.jpg' => '640w', 'pic_1024.jpg' => '1024w', 'pic_1980.jpg' => '1980w' }, sizes: '100vw', class: 'my-image'
  #
  # => <img src="/assets/ants_1980.jpg" srcset="/assets/pic_640.jpg 640w, /assets/pic_1024.jpg 1024w, /assets/pic_1980.jpg 1980w" sizes="100vw" class="my-image">
  #
  def image_set_tag(source, srcset = {}, options = {})
    srcset = srcset.map { |src, size| "#{path_to_image(src)} #{size}" }.join(', ')
    image_tag(source, options.merge(srcset: srcset))
  end
end
