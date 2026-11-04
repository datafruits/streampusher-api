module WikiPagesHelper
  MARKDOWN_EXTENSIONS = [:autolink, :strikethrough, :table, :tagfilter].freeze

  def render_wiki_markdown(markdown)
    rendered = CommonMarker.render_html(markdown.to_s, :DEFAULT, MARKDOWN_EXTENSIONS)

    sanitize(
      rendered,
      tags: %w[a blockquote br code del em h1 h2 h3 h4 h5 h6 hr img li ol p pre strong table tbody td th thead tr ul],
      attributes: %w[alt class height href src title width]
    )
  end
end
