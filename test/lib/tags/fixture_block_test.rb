require_relative '../../test_helper'

class FixtureBlockTest < ActiveSupport::TestCase

  def test_params
    text = "{% fixture identifier:header locale:en %} Hello World{% endfixture %}"
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect {|t| t.params[:identifier] == 'header'}
    assert_equal 'en', tag.params[:locale]
    assert_equal 'header', tag.params[:identifier]
  end

  def test_parses_params
    text = "{% fixture  identifier:header   locale:en   %}Hello{% endfixture %}"
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.first
    expected_params = {identifier: 'header', locale: 'en'}
    assert_equal expected_params, tag.params
  end

  def test_find_by_identifier
    text =  "{% fixture identifier:header locale:en %}Hello{% endfixture %}"
    text += "{% fixture identifier:header locale:fr %}Bonjour{% endfixture %}"
    template = Liquid::Template.parse(text)
    en = template.root.nodelist.detect {|t| t.params[:locale] == 'en' && t.params[:identifier] == 'header'}
    fr = template.root.nodelist.detect {|t| t.params[:locale] == 'fr' && t.params[:identifier] == 'header'}
    assert_equal 'Hello', en.nodelist.first
    assert_equal 'Bonjour', fr.nodelist.first
  end

end

