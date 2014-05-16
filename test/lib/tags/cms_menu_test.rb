require_relative '../../test_helper'

class CmsSnippetTest < ActiveSupport::TestCase

  def setup
    @menu = momentum_cms_menus(:default)
    @site = momentum_cms_sites(:default)
  end

  def test_params
    text = '{% cms_menu slug:foo %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['slug'] == 'foo' }
    assert_equal 'foo', tag.params['slug']
  end

  def test_render

    text = '{% cms_menu slug:snippet %}'

    # Context missing
    template = Liquid::Template.parse(text).render
    assert_equal template, ''

    template = Liquid::Template.parse(text).render(cms_site: @site)
    assert_equal template, ''
  end

end

