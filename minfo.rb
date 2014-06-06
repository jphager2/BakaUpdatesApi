require 'faraday'
require 'nokogiri'

module BakaUpdate
  class Api
    def initialize
      @root = 'http://www.mangaupdates.com'
      @conn = Faraday.new(url: @root) do |f|
        f.request(:url_encoded)
        f.response(:logger)
        f.adapter(Faraday.default_adapter)
      end

    end

    def search(target, post_options)
      Nokogiri::HTML(
        @conn.post(target, post_options).body
      )
    end

    def releases(term)
      search('/search.html', {search: term})
    end

    def manga(type = 'title', term)
      search('/series.html', {stype: type, search: term})
    end

  end
end

