require_relative '../../../test_helper'

class MomentumCms::Admin::SitesControllerTest < ActionController::TestCase
  def setup
    @site = momentum_cms_sites(:default)
  end

  def test_index
    get :index
    assert assigns(:momentum_cms_sites)
  end

  def test_create
    assert_difference 'MomentumCms::Site.count' do
      post :create, momentum_cms_site: { label: 'test2', identifier: 'testtest', host: 'test2.dev' }
    end
  end

  def test_create_invalid
    assert_no_difference 'MomentumCms::Site.count' do
      post :create, momentum_cms_site: { label: @site.label, identifier: @site.identifier, host: @site.host }
      assert_template :new
    end
  end

  def test_update
    put :update, id: @site, momentum_cms_site: { label: 'new label' }
    @site.reload
    assert_equal @site.label, 'new label'
  end

  def test_update_invalid
    put :update, id: @site, momentum_cms_site: { label: '' }
    @site.reload
    refute_equal @site.label, 'new label'
  end

  def test_destroy
    assert_difference 'MomentumCms::Site.count', -1 do
      delete :destroy, id: @site
    end
  end

  def test_destroy_invalid
    assert_no_difference 'MomentumCms::Site.count' do
      delete :destroy, id: 0
    end
  end
end
