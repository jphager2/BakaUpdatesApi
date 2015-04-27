module BU
  class Scanlators
    
    attr_reader :url, :doc 
    def initialize(url, api, scanlators = nil)
      @url = url
      @api = api
      @doc = @api.doc(url_for_page(1))
      @scanlators = scanlators
    end

    def count
      @count ||= all.length
    end

    def all
      scanlators
    end

    def irc_channels
      scanlators.map { |s| s[:irc] }
    end

    def with_irc
      @with_irc ||=
        Scanlators.new(url, @api, scanlators.select { |s| s[:irc][0] }) 
    end

    def active
      @active ||= 
        Scanlators.new(url, @api, scanlators.select { |s| s[:active] }) 
    end

    def search(term)
      scanlators.select { |s| s[:name] =~ /#{term}/i }
    end

    private
    def scanlators 
      return @scanlators if @scanlators

      puts 'Retrieving scanlators...'
      @scanlators = []
      page_numbers.each { |num| scrape_page(num) }
      @scanlators
    end

    def page_numbers
      last = doc.css('a').find { |a| 
        a.text == 'Last' && a[:href].include?("#{url}?page=") 
      }[:href].slice(/#{url}\?page=(\d+)/, 1)
      1..last.to_i
    end

    def scrape_page(num)
      print "#{num}..."
      page_doc = @api.doc(url_for_page(num)) 
      scanlator_rows(page_doc).each do |tr|
        cells = tr.css('td')
        link  = cells.first.css('a').first
        @scanlators << { 
          name: link.text,
          url: link[:href],
          active: !!(cells[1].text =~ /yes/i),
          irc: cells[2].text
        }
      end
    end

    def scanlator_rows(page_doc)
      page_doc.css('tr').select { |tr| 
        tds = tr.children.select { |c| c.name == 'td' }
        if tds.length == 3
          link = tds.first.css('a').first
          link && link[:href].include?("#{url}?id=")
        end
      }
    end

    def url_for_page(num)
      "#{url}?page=#{num}&perpage=100"
    end
  end
end

