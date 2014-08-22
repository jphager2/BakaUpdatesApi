require_relative 'bu/dashboard'
require_relative 'bu/api'

module BU

  ROOT = "http://www.mangaupdates.com"

  def self.url_from_manga_id(id)
    "#{ROOT}/series.html?id=#{id}" 
  end

  def self.absolute_url(url)
    url = ROOT + url if url =~ %r{^/}
    url 
  end

  def self.relative_url(url)
    url.gsub(ROOT, '')
  end
end

