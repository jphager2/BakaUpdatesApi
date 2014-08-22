module BU
  class Dashboard
    
    attr_reader :url, :doc
    def initialize(url, doc)
      @url = url
      @doc = doc
    end

    def to_h
      {
        url:         url,
        title:       title,
        id:          id,
        genres:      genres,
        description: description,
        scanlators:  scanlators,
      }
    end

    def to_s
      to_h.each_with_object('') do |(key,value),out|
        column = key.to_s.upcase
        spaces = 13 - column.length
        out << "\s\s#{column}:#{ " " * spaces}#{value}\n"
      end
    end

    def info
      @info ||= doc.css('.sMember div.sContent')
    end

    def title
      @doc.css('span.releasestitle.tabletitle').first.text
    end

    def id
      Integer(url.sub(/.+id=/, '')) 
    end

    def description
      info[0].text 
    end

    def genres
      info[14].css('a')[0..-2].map {|a| a.text}
    end
    
    def scanlators
      info[4].css('a')
        .select {|a| a.text != "Less..." && a.text != "More..." }
        .map {|a| {url: a[:href], name: a.text} }
    end
  end
end
