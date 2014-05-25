require 'test_helper'

class MomentumCms::Api::Admin::SitesControllerTest < ActionController::TestCase

  def setup
    @default_site = momentum_cms_sites(:default)
  end

  def test_index
    get :index
    assert_response :success
    assert assigns(:sites)
    assert_equal @default_site.label, json_response['sites'][1]['label']
    assert_equal @default_site.identifier, json_response['sites'][1]['identifier']
    assert_equal @default_site.host, json_response['sites'][1]['host']
    assert_equal @default_site.title, json_response['sites'][1]['title']
    assert_equal @default_site.default_locale, json_response['sites'][1]['default_locale']
    assert_equal @default_site.available_locales, json_response['sites'][1]['available_locales']
  end

  def test_create
    assert_difference "MomentumCms::Site.count" do
      post :create, site: {
        title: 'Api Site',
        identifier: 'api-site',
        host: 'test.dev',
        label: 'Api Site',
        default_locale: ['en'],
        available_locales: ['en', 'fr']
      }
    end
    site = MomentumCms::Site.last
    assert_response :success
    assert assigns(:site)
    assert_equal site.label, json_response['site']['label']
    assert_equal site.identifier, json_response['site']['identifier']
    assert_equal site.host, json_response['site']['host']
    assert_equal site.title, json_response['site']['title']
    assert_equal site.default_locale, json_response['site']['default_locale']
    assert_equal site.available_locales, json_response['site']['available_locales']
  end

end
