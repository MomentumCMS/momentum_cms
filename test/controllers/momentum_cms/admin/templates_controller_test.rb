require_relative '../../../test_helper'

class MomentumCms::Admin::TemplatesControllerTest < ActionController::TestCase

  def setup
    @site = momentum_cms_sites(:default)
    @template = momentum_cms_templates(:default)
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
        label: 'Test Create',
        identifier: 'test-create'
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
      parent_id: parent_template.id,
      identifier: 'test-create'
    }
    template = MomentumCms::Template.last
    assert_equal parent_template, template.parent
  end

  def test_create_invalid
    assert_no_difference "MomentumCms::Template.count" do
      post :create, site_id: @site.id, momentum_cms_template: {}
      assert_template :new
    end
  end

  def test_edit
    get :edit, site_id: @site.id, id: @template
    assert_template :edit
  end

  def test_edit_invalid
    get :edit, site_id: @site.id, id: 0
    assert_redirected_to cms_admin_site_templates_path
  end

  def test_update
    put :update, site_id: @site.id, id: @template, momentum_cms_template: {
      label: 'New Label'
    }
    @template.reload
    assert_equal 'New Label', @template.label
  end

  def test_update_invalid
    put :update, site_id: @site.id, id: @template, momentum_cms_template: {
      label: ''
    }
    @template.reload
    refute_equal '', @template.label
    assert_template :edit
  end

  def test_destroy
    assert_difference 'MomentumCms::Template.count', -1 do
      delete :destroy, site_id: @site.id, id: @template
    end
  end

  def test_destroy_permanent_record
    @template.permanent_record = true
    @template.save!
    assert_no_difference 'MomentumCms::Template.count' do
      delete :destroy, site_id: @site.id, id: @template
    end
  end

  def test_destroy_invalid
    assert_no_difference 'MomentumCms::Template.count' do
      delete :destroy, site_id: @site.id, id: 0
    end
  end
end
