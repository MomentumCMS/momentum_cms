require_relative '../../test_helper'

class MomentumCms::PagesControllerTest < ActionController::TestCase

  def setup
    @site = momentum_cms_sites(:default)
    @site.save!
    @site.reload
    @request.host = @site.host

    @parent_template = momentum_cms_templates(:default)
    @child_template = momentum_cms_templates(:child)
    @child_template.parent = @parent_template
    @child_template.save

    @default_page = momentum_cms_pages(:default)
    @default_page.slug = '/'
    @default_page.site = @site
    @default_page.save!
    @default_page.reload

    @child_page = momentum_cms_pages(:child)
    @child_page.slug = 'child'
    @child_page.site = @site
    @child_page.parent = @parent_page
    @child_page.save!
    @child_page.reload
  end

  def test_site_not_found
    MomentumCms::Site.delete_all
    assert_nothing_raised do
      @request.host = 'foobar.com'
      get :show, id: @default_page.path
    end
  end

  def test_show
    get :show, id: @default_page.path
    assert_equal 'default ', response.body
    assert_response :success

    get :show, id: @child_page.path
    assert_equal 'default child', response.body
    assert_response :success
  end

  def test_show_invalid
    get :show, id: '/something'
    assert_response 404
  end

  def test_css
    get :css, id: @child_page.id, format: :css
    assert_equal ".default{}\n.child{}\n", response.body
  end

  def test_css_invalid
    get :css, id: 0, format: :css
    assert_equal "".strip, response.body.strip
  end

  def test_js
    # Security warning: an embedded <script> tag on another site requested protected JavaScript. If you know what you're doing, go ahead and disable forgery protection on this action to permit cross-origin JavaScript embedding.
    #get :js, id: @child_page.id, format: :js
  end
end
