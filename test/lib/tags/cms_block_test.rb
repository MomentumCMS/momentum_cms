require_relative '../../test_helper'

class CmsBlockTest < ActiveSupport::TestCase

  def test_params
    text = '{% cms_block id:header %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['id'] == 'header' }
    assert_equal 'header', tag.params['id']
  end

  def test_parses_params
    text = '{% cms_block id:header %}'
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.first
    expected_params = { 'id' => 'header' }
    assert_equal expected_params, tag.params
  end

  def test_render_block_tag
    text = '{% cms_block id:default %}'
    template = Liquid::Template.parse(text)
    render = template.render
    assert_equal render, ''

    block = momentum_cms_blocks(:default)
    block.block_template = momentum_cms_block_templates(:default)
    block.value = 'foobar'
    block.save!

    momentum_cms_pages(:default).publish!
    
    render = template.render(cms_page: momentum_cms_pages(:default))
    assert_equal render, 'foobar'
  end

end

