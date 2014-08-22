require_relative '../../test_helper'

class ApiTest < Minitest::Test

  def setup
    @api = BU::Api.new
  end

  def test_returns_dashboard
    assert_kind_of BU::Dashboard, @api.dashboard('one piece')
  end

  def test_fails_if_no_series_dashboard_is_found
    assert_raises(BU::NotFound) do
      @api.dashboard('no way that this is a manga title')
    end 
  end
end
