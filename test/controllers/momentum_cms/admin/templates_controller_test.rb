require_relative '../../../test_helper'

class MomentumCms::Admin::TemplatesControllerTest < ActionController::TestCase

  def setup
    @site = momentum_cms_sites(:default)
  end

  def test_index
    get :index, site_id: @site.id
    assert_response :success
    assert_template :index
    assert assigns(:momentum_cms_templates)
  end

  def test_new
    get :new, site_id: @site.id
    assert_response :success
    assert_template :new
    assert assigns(:momentum_cms_templates)
    assert assigns(:momentum_cms_template)
  end

  def test_create
    assert_difference "MomentumCms::Template.count" do
      post :create, site_id: @site.id, momentum_cms_template: {
        label: 'Test Create'
      }
      template = MomentumCms::Template.last
      assert_response :redirect
      assert_redirected_to edit_cms_admin_site_template_path(@site, template)
    end
  end

  def test_create_with_child
    parent_template = momentum_cms_templates(:default)
    post :create, site_id: @site.id, momentum_cms_template: {
      label: 'Test Create',
      parent_id: parent_template.id
    }
    template = MomentumCms::Template.last
    assert_equal parent_template, template.parent
  end

end
