require_relative '../test_helper'

class BuTest < Minitest::Test

  def setup
    @relative_url = '/series.html?id=42466'
    @absolute_url = 'http://www.mangaupdates.com/series.html?id=42466'
  end
 
  def test_urls
    assert_equal @relative_url, BU.relative_url(@absolute_url), "abs to rel" 
    assert_equal @absolute_url, BU.absolute_url(@relative_url), "rel to abs" 
  end

  def test_series_url_from_id
    assert_equal @absolute_url, BU.series_url_from_id(42466)
  end
end

