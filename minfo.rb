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

    def doc(url)
      Nokogiri::HTML(@conn.get(url).body)
    end

    def search(target, post_options)
      Nokogiri::HTML(
        @conn.post(target, post_options).body
      )
    end

    def releases(term)
      search('/search.html', {search: term})
    end

    def manga(term, type: 'title')
      search('/series.html', {stype: type, search: term})
    end

    def series_url(manga)
      doc = manga(manga)
      link = doc.css('a').find do |a| 
        a[:alt] == "Series Info" && a.text.downcase == manga.downcase
      end  
      link ? link[:href].sub(@root, '') : :no_match
    end

    def series_description(info)
      info[0].text 
    end

    def series_genres(info)
      info[14].css('a')[0..-2].map {|a| a.text}
    end
    
    def series_scanlators(info)
      info[4].css('a')
        .select {|a| a.text != "Less..." && a.text != "More..." }
        .map {|a| {uri: a[:href], name: a.text} }
    end

    def series_dashboard(manga)
      url = series_url(manga)
      info = doc(url).css('.sMember div.sContent')
      {
        id:           Integer(url.sub(/.+id=/, '')), 
        description:  series_description(info),
        genres:       series_genres(info),
        scanlators:   series_scanlators(info),
      }
    end
  end
end

