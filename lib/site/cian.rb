require_relative '../site'

class Site::Cian < Site
  def provider
    'Cian'
  end

  def url_to_flat_css
    '.objects_item_link > a'
  end

  def normalize_url(url)
    url
  end
end
