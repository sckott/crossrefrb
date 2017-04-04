require 'simplecov'
SimpleCov.start
if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "serrano"
require 'fileutils'
require "test/unit"
require "json"

class TestFunders < Test::Unit::TestCase

  def setup
    @id = 100004410
    @ids = ['10.13039/100000001','10.13039/100000015']
  end

  def test_funders
    res = Serrano.funders(ids: @id)
    assert_equal(1, res.length)
    assert_equal(Array, res.class)
    assert_equal(Hash, res[0].class)
    assert_equal("funder", res[0]['message-type'])
  end

  def test_funders_many_ids
    res = Serrano.funders(ids: @ids)
    assert_equal(2, res.length)
    assert_equal(Array, res.class)
    assert_equal(Hash, res[0].class)
    assert_equal("funder", res[0]['message-type'])
    assert_equal("National Science Foundation", res[0]['message']['name'])
  end

  def test_funders_query
    res = Serrano.funders(query: "NSF")
    assert_equal(4, res.length)
    assert_equal(Hash, res.class)
    assert_equal("funder-list", res['message-type'])
  end

  def test_funders_filter_handler
    exception = assert_raise(Serrano::BadRequest) {Serrano.funders(filter: {has_funder: true})}
    assert_equal("\n   GET https://api.crossref.org/funders?filter=has-funder%3Atrue\n   Status 400: Filter has-funder specified but there is no such filter for this route. Valid filters for this route are: location",
      exception.message)
  end

end
