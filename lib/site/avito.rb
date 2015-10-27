require_relative '../site'

class Site::Avito < Site
  def provider
    'Avito'
  end

  def url_to_flat_css
    'h3.title > a'
  end

  def normalize_url(url)
    if url[/http/]
      url
    else
      "https://www.avito.ru#{url}"
    end
  end
end
