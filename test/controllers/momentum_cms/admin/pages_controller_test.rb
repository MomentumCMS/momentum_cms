require_relative '../../../test_helper'

class MomentumCms::Admin::PagesControllerTest < ActionController::TestCase

  def setup
    @site = momentum_cms_sites(:default)
    @page = momentum_cms_pages(:default)
    @template = momentum_cms_templates(:default)
    MomentumCms::Page.all.each do |page|
      page.slug = "#{page.id}-slug"
      page.save!
    end
  end

  def test_index
    get :index, site_id: @site

    assert assigns(:momentum_cms_pages)
  end

  def test_index_new
    MomentumCms::Site.destroy_all
    get :index, site_id: 0
    assert_redirected_to new_cms_admin_site_path
  end

  def test_new
    get :new, site_id: @site.id
    assert_response :success
    page = assigns(:momentum_cms_page)
    assert page.present?
  end

  def test_edit
    get :edit, site_id: @site.id, id: @page
    assert_template :edit
  end

  def test_edit_invalid
    get :edit, site_id: @site.id, id: 0
    assert_redirected_to cms_admin_site_pages_path
  end

  def test_create
    assert_difference "MomentumCms::Page.count" do
      post :create, site_id: @site.id, momentum_cms_page: {
        label: 'Test Create',
        slug: 'test-create',
        identifier: 'test-create',
        template_id: @template.id
      }
    end
    assert_response :redirect
    page = MomentumCms::Page.last
    assert_redirected_to edit_cms_admin_site_page_path(@site, page)
  end

  def test_create_invalid
    assert_difference 'MomentumCms::Page.count' do
      post :create, site_id: @site.id, momentum_cms_page: { slug: 'slug', identifier: 'slug', template_id: @template.id }
    end
    assert_no_difference 'MomentumCms::Page.count' do
      post :create, site_id: @site.id, momentum_cms_page: { slug: 'slug', identifier: 'slug', template_id: @template.id }
    end
  end

  def test_update
    put :update, site_id: @page.site.id, id: @page.id, momentum_cms_page: {
      label: 'Updated',
    }
    @page.reload
    assert_equal 'Updated', @page.label
  end

  def test_update_invalid
    post :create, site_id: @site.id, momentum_cms_page: { slug: 'slug', identifier: 'slug', template_id: @template.id }

    put :update, site_id: @page.site.id, id: @page.id, momentum_cms_page: {
      slug: 'slug'
    }

    assert_template :edit
  end

  def test_destroy
    assert_difference 'MomentumCms::Page.count', -1 do
      delete :destroy, site_id: @site.id, id: @page
    end
  end

  def test_destroy_invalid
    assert_no_difference 'MomentumCms::Page.count' do
      delete :destroy, site_id: @site.id, id: 0
    end
  end

end
