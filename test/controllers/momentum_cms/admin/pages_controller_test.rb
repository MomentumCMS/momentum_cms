require 'test_helper'

class MomentumCms::Admin::PagesControllerTest < ActionController::TestCase

  def setup
    @site = momentum_cms_sites(:default)
  end

  def test_new
    get :new, site_id: @site.id
    assert_response :success
    page = assigns(:momentum_cms_page)
    content = page.contents.default
    assert page.contents.present?
  end

  def test_create
    assert_difference "MomentumCms::Page.count" do
      assert_difference "MomentumCms::Content.count" do
        post :create, site_id: @site.id, momentum_cms_page: {
          label: 'Test Create'
        }
      end
    end
    assert_response :redirect
    page = MomentumCms::Page.last
    content = page.contents.default.first
    assert_redirected_to edit_cms_admin_site_page_content_path(@site, page, content)
  end

end
