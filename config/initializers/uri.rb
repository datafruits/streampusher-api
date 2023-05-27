module URI
  def URI.escape(url)
    CGI.escape(url)
  end
end
