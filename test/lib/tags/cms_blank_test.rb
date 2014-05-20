require_relative '../../test_helper'

class CmsBlankTest < ActiveSupport::TestCase

  def setup
    @object = Object.new
    @object.extend(MomentumCms::Tags::CmsLiquidUtils)

  end

  def test_context
    assert_equal @object.context_get({ :foo => 'bar' }, :bar, :baz), :baz
  end

  def test_params

    params = nil
    string = 'id:header'
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'

    params = nil
    string = '    id:header     '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'

    params = nil
    string = '  foo:bar  id:header     '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'
    assert params.has_key?('foo')
    assert_equal params['foo'], 'bar'

    params = nil
    string = '  foo:bar  id:header  foo:baz    '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'
    assert params.has_key?('foo')
    assert_equal params['foo'], 'baz'

    params = nil
    string = '  foo:"bar baz"  id:header   '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'
    assert params.has_key?('foo')
    assert_equal params['foo'], 'bar baz'

    params = nil
    string = '  "foo bar":"bar baz"  id:header   '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'
    assert params.has_key?('foo bar')
    assert_equal params['foo bar'], 'bar baz'

    params = nil
    string = '  "foo bar":"bar:baz"  id:header   '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'
    assert params.has_key?('foo bar')
    assert_equal params['foo bar'], 'bar:baz'

    params = nil
    string = '  "foo:bar":"bar:baz"  id:header   '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'
    assert params.has_key?('foo:bar')
    assert_equal params['foo:bar'], 'bar:baz'

    params = nil
    string = '  "foo bar":"\""  id:header  "foo \"baz\" bar":"baxton"  '
    params = @object.parse_params(string)
    assert params.has_key?('id')
    assert_equal params['id'], 'header'
    assert params.has_key?('foo bar')
    assert_equal params['foo bar'], '"'
    assert params.has_key?('foo "baz" bar')
    assert_equal params['foo "baz" bar'], 'baxton'

    params = nil
    string = '  "foo bar""\""  idheader  "foo \"baz\" bar""baxton"  '
    params = @object.parse_params(string)
    assert_equal params, {}

    params = nil
    string = 'cheesecake'
    params = @object.parse_params(string)
    assert_equal params, {}

    params = nil
    string = nil
    params = @object.parse_params(string)
    assert_equal params, {}
  end
end

