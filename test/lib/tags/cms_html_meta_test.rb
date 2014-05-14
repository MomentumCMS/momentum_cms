require_relative '../../test_helper'

class CmsHtmlMetaTest < ActiveSupport::TestCase

  def test_params
    page = momentum_cms_pages(:default)
    text = '{% cms_html_meta type:js %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['type'] == 'js' }
    assert_equal 'js', tag.params['type']
    assert_equal "<script src=\"/momentum_cms/js/#{page.id}.js\"></script>", template.render(cms_page: page)

    text = '{% cms_js %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['type'] == 'js' }
    assert_equal 'js', tag.params['type']
    assert_equal "<script src=\"/momentum_cms/js/#{page.id}.js\"></script>", template.render(cms_page: page)

    text = '{% cms_html_meta type:js %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['type'] == 'js' }
    assert_equal 'js', tag.params['type']
    assert_equal '', template.render

    text = '{% cms_html_meta type:css %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['type'] == 'css' }
    assert_equal 'css', tag.params['type']
    assert_equal "<link href=\"/momentum_cms/css/#{page.id}.css\" media=\"screen\" rel=\"stylesheet\" />", template.render(cms_page: page)

    text = '{% cms_css %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['type'] == 'css' }
    assert_equal 'css', tag.params['type']
    assert_equal "<link href=\"/momentum_cms/css/#{page.id}.css\" media=\"screen\" rel=\"stylesheet\" />", template.render(cms_page: page)

    text = '{% cms_html_meta type:css %}'
    template = Liquid::Template.parse(text)
    assert_equal 'css', tag.params['type']
    assert_equal '', template.render

    text = '{% cms_html_meta %}'
    template = Liquid::Template.parse(text)
    assert_equal '', template.render(cms_page: page)

    text = '{% cms_html_meta type:js type:css %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['type'] == 'css' }
    assert_equal 'css', tag.params['type']
    assert_equal "<link href=\"/momentum_cms/css/#{page.id}.css\" media=\"screen\" rel=\"stylesheet\" />", template.render(cms_page: page)

  end


end

