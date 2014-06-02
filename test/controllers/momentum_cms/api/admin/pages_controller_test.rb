require 'test_helper'

class MomentumCms::Api::Admin::PagesControllerTest < ActionController::TestCase

  def setup
    @default_site = momentum_cms_sites(:default)
    @default_page = momentum_cms_pages(:default)
  end

  def test_index
    get :index, site_id: @default_site.id
    puts json_response.inspect
    assert_response :success
    assert assigns(:site)
    assert assigns(:pages)
    assert_equal @default_page.id, json_response['pages'][1]['id']
    assert_equal @default_page.label, json_response['pages'][1]['label']
    assert_equal @default_page.identifier, json_response['pages'][1]['identifier']
  end

  def test_create
    @template = momentum_cms_templates(:default)
    assert_difference "MomentumCms::Page.count" do
      post :create, page: {
        label: 'Api Page',
        identifier: 'api-page',
        slug: 'api-page',
        template_id: @template.id,
        site_id: @default_site.id
      }
    end
    page = MomentumCms::Page.last
    assert_response :success
    assert assigns(:page)
    assert_equal page.label, json_response['page']['label']
    assert_equal page.identifier, json_response['page']['identifier']
    assert_equal page.slug, json_response['page']['slug']
  end

  def test_update
    page = momentum_cms_pages(:default)
    patch :update, id: page.id, page: {
      label: 'New Label',
      slug: 'new-label'
    }
    assert_response :success
    page.reload
    assert_equal 'New Label', page.label
    assert_equal 'new-label', page.slug
  end

  def test_failed_update
    page = momentum_cms_pages(:default)
    patch :update, id: page.id, page: {
      label: 'New Label',
      slug: nil
    }
    assert_response 422
    assert json_response['errors'].present?
  end

  def test_create_failure
    assert_no_difference "MomentumCms::Page.count" do
      post :create, site_id: @default_site.id, page: {}
    end
    assert_response 422
    assert assigns(:page)
    assert json_response['errors'].present?
    assert json_response['errors']['slug'].present?
    assert json_response['errors']['identifier'].present?
    assert json_response['errors']['template'].present?
  end

end
