require_relative '../../test_helper'

class CmsYieldTest < ActiveSupport::TestCase

  def test_params
    text = '{% cms_yield %}'
    template = Liquid::Template.parse(text)
    assert_equal '', template.render

    template = Liquid::Template.parse(text)
    assert_equal 'test', template.render(yield: 'test')

    text = '{% cms_yield %}{% cms_yield %}'
    template = Liquid::Template.parse(text)
    assert_equal 'testtest', template.render(yield: 'test')
  end
end

