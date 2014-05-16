require_relative '../../test_helper'

class MomentumCms::AdminHelperTest < ActionView::TestCase

  def test_edit_momentum_content_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    @momentum_cms_page = momentum_cms_pages(:default)
    @momentum_cms_content = @momentum_cms_page.contents.first
    edit_url = edit_cms_admin_site_page_content_path(@current_momentum_cms_site, @momentum_cms_page, @momentum_cms_content)
    assert_equal edit_url, edit_momentum_content_url(@momentum_cms_content)
  end

  def test_new_momentum_content_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    @momentum_cms_page = momentum_cms_pages(:default)
    new_url = new_cms_admin_site_page_content_path(@current_momentum_cms_site, @momentum_cms_page)
    assert_equal new_url, new_momentum_content_url
  end

  def test_momentum_content_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    @momentum_cms_page = momentum_cms_pages(:default)
    @momentum_cms_content = @momentum_cms_page.contents.first
    content_url = cms_admin_site_page_content_path(@current_momentum_cms_site, @momentum_cms_page, @momentum_cms_content)
    assert_equal content_url, momentum_content_url(@momentum_cms_content)
  end

  def test_momentum_contents_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    @momentum_cms_page = momentum_cms_pages(:default)
    contents_url = cms_admin_site_page_contents_path(@current_momentum_cms_site, @momentum_cms_page)
    assert_equal contents_url, momentum_contents_url
  end

  def test_momentum_page_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    @momentum_cms_page = momentum_cms_pages(:default)
    page_url = cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
    assert_equal page_url, momentum_page_url
  end

  def test_momentum_pages_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    pages_url = momentum_pages_url
    assert_equal cms_admin_site_pages_path(@current_momentum_cms_site), pages_url
  end

  def test_edit_momentum_page_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    @momentum_cms_page = momentum_cms_pages(:default)
    edit_url = edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
    assert_equal edit_url, edit_momentum_page_url
  end

  def test_new_momentum_page_url
    @current_momentum_cms_site = momentum_cms_sites(:default)
    new_url = new_cms_admin_site_page_path(@current_momentum_cms_site)
    assert_equal new_url, new_momentum_page_url
  end

end