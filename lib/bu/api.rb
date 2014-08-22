require 'faraday'
require 'nokogiri'

module BU
  class Api
    def initialize
      @conn = Faraday.new(url: BU::ROOT) do |f|
        f.request(:url_encoded)
        # f.response(:logger) # for debugging
        f.adapter(Faraday.default_adapter)
      end
    end

    def dashboard(manga)
      url = series_url(manga)
      BU::Dashboard.new(url, doc(url))
    end

    private 
      def doc(url)
        Nokogiri::HTML(@conn.get(url).body)
      end

      def search(target, post_options)
        Nokogiri::HTML(@conn.post(target, post_options).body)
      end

      def releases(term)
        search('/search.html', {search: term})
      end

      def manga(term, type: 'title')
        search('/series.html', {stype: type, search: term})
      end

      def match_names(name, other)
        name = name.clone.gsub(/\W/, '')
        other = other.clone.gsub(/\W/, '')
        name.downcase == other.downcase
      end

      def series_url(manga)
        doc = manga(manga)
        link = doc.css('a').find do |a| 
          a[:alt] == "Series Info" && match_names(a.text, manga)
        end  
        raise BU::NotFound unless link
        link[:href].sub(BU::ROOT, '')
      end
  end
end
