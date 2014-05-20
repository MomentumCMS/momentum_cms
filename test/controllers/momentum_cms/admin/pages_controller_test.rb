require_relative '../../../test_helper'

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
      post :create, site_id: @site.id, momentum_cms_page: {
        label: 'Test Create',
        slug: 'test-create'
      }
    end
    assert_response :redirect
    page = MomentumCms::Page.last
    content = page.contents.default.first
    assert_redirected_to edit_cms_admin_site_page_path(@site, page)
  end

  def test_update
    page = momentum_cms_pages(:default)
    content = page.contents.create!(label: 'New Content')
    put :update, site_id: page.site.id, id: page.id, momentum_cms_page: {
      label: 'Updated',
      published_content_id: content.id
    }
    page.reload
    assert_equal 'Updated', page.label
    assert_equal content.id, page.published_content_id
  end

end
