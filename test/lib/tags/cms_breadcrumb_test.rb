require_relative '../../test_helper'

class CmsBreadcrumbTest < ActiveSupport::TestCase

  def test_params
    text = '{% cms_breadcrumb slug:foo %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['slug'] == 'foo' }
    assert_equal 'foo', tag.params['slug']
  end

  def test_render
    page_parent = momentum_cms_pages(:default)
    page_parent.published_content_id = momentum_cms_contents(:default).id
    page_parent.save

    page_child = momentum_cms_pages(:child)
    page_child.published_content_id = momentum_cms_contents(:child).id
    page_child.parent = page_parent
    page_child.save

    text = '{% cms_breadcrumb %}'

    # Context missing
    template = Liquid::Template.parse(text).render
    assert_equal template, ''

    template = Liquid::Template.parse(text).render(cms_page: page_child)
    refute_equal template, ''
    assert template.include?('ol')

    text = '{% cms_breadcrumb outer_tag:div outer_class:div-class inner_tag:pre inner_class:"pre-class" %}'

    template = Liquid::Template.parse(text).render(cms_page: page_child)
    refute_equal template, ''

    assert template.include?('<div')
    assert template.include?('class="div-class"')
    assert template.include?('<pre')
    assert template.include?('class="pre-class"')
  end

end

