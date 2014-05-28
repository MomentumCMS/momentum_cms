require 'test_helper'

class MomentumCms::Api::Admin::TemplatesControllerTest < ActionController::TestCase

  def setup
    @default_template = momentum_cms_templates(:default)
  end

  def test_index
    get :index
    assert_response :success
    assert assigns(:templates)
    assert_equal @default_template.label, json_response['templates'][1]['label']
    assert_equal @default_template.identifier, json_response['templates'][1]['identifier']
    assert_equal @default_template.css, json_response['templates'][1]['css']
    assert_equal @default_template.js, json_response['templates'][1]['js']
    assert_equal @default_template.value, json_response['templates'][1]['value']
    assert_equal @default_template.admin_value, json_response['templates'][1]['admin_value']
    assert_equal @default_template.permanent_record, json_response['templates'][1]['permanent_record']
    assert_equal @default_template.site_id, json_response['templates'][1]['site_id']
  end

  def test_create
    assert_difference "MomentumCms::Template.count" do
      post :create, template: {
        label: 'api-template',
        identifier: 'api-site',
        css: 'css',
        js: 'js',
        value: 'value',
        admin_value: 'value',
        site_id: momentum_cms_sites(:default).id,
        permanent_record: false
      }
    end
    template = MomentumCms::Template.last
    assert_response :success
    assert assigns(:template)
    assert_equal template.label, json_response['template']['label']
    assert_equal template.identifier, json_response['template']['identifier']
    assert_equal template.css, json_response['template']['css']
    assert_equal template.js, json_response['template']['js']
    assert_equal template.value, json_response['template']['value']
    assert_equal template.admin_value, json_response['template']['admin_value']
    assert_equal template.site_id, json_response['template']['site_id']
    assert_equal template.permanent_record, json_response['template']['permanent_record']
  end

  def test_create_failure
    assert_no_difference "MomentumCms::Template.count" do
      post :create, template: {}
    end
    assert_response 422
    assert json_response['errors'].present?
    assert json_response['errors']['label'].present?
    assert json_response['errors']['identifier'].present?
    assert json_response['errors']['site_id'].present?
  end

end
