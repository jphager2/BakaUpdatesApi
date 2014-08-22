require_relative 'bu/dashboard'
require_relative 'bu/api'

module BU

  ROOT = "http://www.mangaupdates.com"

  def self.series_url_from_id(id)
    absolute_url("/series.html?id=#{id}") 
  end

  def self.absolute_url(url)
    url = ROOT + url if url =~ %r{^/}
    url 
  end

  def self.relative_url(url)
    url.gsub(ROOT, '')
  end

  class NotFound < Exception
  end
end

