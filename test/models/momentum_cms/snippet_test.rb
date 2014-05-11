require 'test_helper'

class MomentumCms::SnippetTest < ActiveSupport::TestCase
  def setup
    @site = momentum_cms_sites(:default)
  end

  def test_fixture_validity
    MomentumCms::Snippet.all.each do |snippet|
      assert snippet.valid?
    end
  end

  def test_create
    assert_difference 'MomentumCms::Snippet.count' do
      MomentumCms::Snippet.create(
        label: 'Snippet Name',
        slug: 'slug',
        site: @site
      )
    end
    assert_no_difference 'MomentumCms::Snippet.count' do
      MomentumCms::Snippet.create(
        label: 'Snippet Name',
        slug: 'slug',
        site: @site
      )
    end
  end

  def test_assign_identifier
    assert_difference 'MomentumCms::Snippet.count' do
      MomentumCms::Snippet.create(
        label: 'Snippet Name',
        site: @site
      )
    end
  end
end
