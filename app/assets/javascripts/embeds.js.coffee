$('[data-controller=embeds][data-action=index]').ready ->
  base_embed_url = $("input#embed-url").val()
  embed_url = base_embed_url
  embed_code = '''
"<iframe width="100%" height="100" frameborder="no" scrolling="no" src="#{embed_url}"></iframe>"
'''
  $("#colorpicker").spectrum({
    color: "#f00",
    change: (color) ->
      embed_url = "#{base_embed_url}?color=#{color.toHexString().replace(/#/, "")}"
      embed_code = """
      <iframe width="100%" height="100" frameborder="no" scrolling="no" src="#{embed_url}"></iframe>
      """
      $("textarea#embed-player-html").val(embed_code)
      $("iframe#embed-preview").attr("src", embed_url)
  })
