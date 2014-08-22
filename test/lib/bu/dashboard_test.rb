require_relative '../../test_helper'

require 'open-uri'

class DashboardTest < Minitest::Test
  def setup
    uri = 'http://www.mangaupdates.com/series.html?id=34771'
    doc = Nokogiri::HTML(open(uri).read)
    @dashboard = BU::Dashboard.new(uri, doc)
  end

  def test_to_h
    keys = %w( title id url description genres scanlators ).map(&:to_sym)
    assert_equal keys.sort, @dashboard.to_h.keys.sort 
  end

  def test_to_s
    assert_includes @dashboard.to_s, "TITLE:"
  end

  def test_access_keys_directly
    assert @dashboard.id, 'access id'
    assert @dashboard.url, 'access url'
    assert @dashboard.description, 'access description'
    assert @dashboard.title, 'access title'
    assert @dashboard.genres, 'access genres'
    assert @dashboard.scanlators, 'access scanlators'
  end
end
