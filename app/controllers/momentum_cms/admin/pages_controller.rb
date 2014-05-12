class MomentumCms::Admin::PagesController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_page, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_page, only: [:new, :create]

  def index
    @momentum_cms_pages = @current_momentum_cms_site.pages.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_page.save!
    flash[:success] = 'Page was successfully created.'
    redirect_to edit_cms_admin_site_page_content_path(@current_momentum_cms_site, @momentum_cms_page, @momentum_cms_page.contents.default.first)
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_page.update_attributes!(momentum_cms_page_params)
    flash[:success] = 'Page was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_page
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_page.destroy
    flash[:success] = 'Page was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_page
    @momentum_cms_page = MomentumCms::Page.find(params[:id])
  end

  def build_moment_cms_page
    @momentum_cms_page = MomentumCms::Page.new(momentum_cms_page_params)
    @momentum_cms_page.site = @current_momentum_cms_site
  end

  def momentum_cms_page_params
    params.fetch(:momentum_cms_page, {}).permit!
  end
end
