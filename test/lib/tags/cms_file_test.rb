require_relative '../../test_helper'

class CmsFileTest < ActiveSupport::TestCase
  def setup
    @site = momentum_cms_sites(:default)
    @file = MomentumCms::File.new
    @file.site = @site
    @file.file = File.new('test/fixtures/files/text.txt')
    @file.identifier = 'slug-for-test-file'
    @file.save!
  end

  def test_params
    text = "{% cms_file id:#{@file.identifier} %}"
    template = Liquid::Template.parse(text)
    tag = template.root.nodelist.detect { |t| t.params['id'] == @file.identifier }
    assert_equal @file.identifier, tag.params['id']
    assert_equal @file.file.url(:original, timestamp: false), template.render(cms_site: @site)

    text = '{% cms_file %}'
    template = Liquid::Template.parse(text)
    assert_equal '', template.render
  end
end

