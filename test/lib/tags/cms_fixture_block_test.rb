require_relative '../../test_helper'

class CmsFixtureBlockTest < ActiveSupport::TestCase

  def test_params
    text = '{% cms_fixture id:header locale:en %} Hello World{% endcms_fixture %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['id'] == 'header' }
    assert_equal 'en', tag.params['locale']
    assert_equal 'header', tag.params['id']
  end

  def test_parses_params
    text = '{% cms_fixture  id:header   locale:en   %}Hello{% endcms_fixture %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.first
    expected_params = { 'id' => 'header', 'locale' => 'en' }
    assert_equal expected_params, tag.params
  end

  def test_find_by_identifier
    text = '{% cms_fixture id:header locale:en %}Hello{% endcms_fixture %}'
    text += '{% cms_fixture id:header locale:fr %}Bonjour{% endcms_fixture %}'
    template = Liquid::Template.parse(text)
    en = template.root.nodelist.detect { |t| t.params['locale'] == 'en' && t.params['id'] == 'header' }
    fr = template.root.nodelist.detect { |t| t.params['locale'] == 'fr' && t.params['id'] == 'header' }
    assert_equal 'Hello', en.nodelist.first
    assert_equal 'Bonjour', fr.nodelist.first
  end

  def test_multiline
    text = '{% cms_fixture id:content locale:en %}before{% raw %}{% cms_file id:1 %}{% endraw %}after{% endcms_fixture %}'
    template = Liquid::Template.parse(text)
    en = template.root.nodelist.detect { |t| t.params['locale'] == 'en' && t.params['id'] == 'content' }
    results = MomentumCms::Tags::CmsFixture.get_contents(en)
    assert_equal 'before{% cms_file id:1 %}after', results
  end

  def test_fixture_invalid
    text = '{% cms_breadcrumb %}'
    template = Liquid::Template.parse(text)
    en = template.root.nodelist.detect { |t| t.params['locale'] == 'en' && t.params['id'] == 'content' }
    results = MomentumCms::Tags::CmsFixture.get_contents(en)
    assert_equal '', results
  end

end

