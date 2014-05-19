class MomentumCms::Admin::PagesController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_page, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_page, only: [:new, :create]
  before_action :load_parent_pages, only: [:edit, :new, :update, :create]

  def index
    @momentum_cms_pages = @current_momentum_cms_site.pages.all
  end

  def new
    @momentum_cms_page.build_default_content if @momentum_cms_page.contents.length == 0
  end

  def edit
    if params[:new_content]
      @momentum_cms_page.contents.build(default: false)
    end
  end

  def create
    @momentum_cms_page.save!
    flash[:success] = 'Page was successfully created.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  rescue ActiveRecord::RecordInvalid
    Rails.logger.info @momentum_cms_page.errors.inspect
    @momentum_cms_page.build_default_content if @momentum_cms_page.contents.length == 0
    render action: :new
  end

  def update
    @momentum_cms_page.update_attributes!(momentum_cms_page_params)
    flash[:success] = 'Page was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_page
  rescue ActiveRecord::RecordInvalid
    Rails.logger.info @momentum_cms_page.contents.inspect
    Rails.logger.info @momentum_cms_page.errors.inspect
    render action: :edit
  end

  def destroy
    @momentum_cms_page.destroy
    flash[:success] = 'Page was successfully destroyed.'
    redirect_to action: :index
  end

  def content_blocks
    @momentum_cms_template = MomentumCms::Template.find(params[:template_id])
    if params[:page_id].present?
      @momentum_cms_page = MomentumCms::Page.find(params[:page_id])
    else
      build_moment_cms_page
    end
    if params[:content_id].present?
      @momentum_cms_content = MomentumCms::Content.find(params[:content_id])
    else
      @momentum_cms_content = @momentum_cms_page.contents.build
    end
    @momentum_cms_content.template_id = params[:template_id]
    @content_blocks = @momentum_cms_content.blocks.to_a
    @defined_blocks = TemplateBlockService.new(@momentum_cms_template).get_blocks.delete_if do |v|
      !@content_blocks.detect { |x| x.identifier == v.params[:id] }.nil?
    end
    @defined_blocks.each do |block|
      @momentum_cms_content.blocks.build(identifier: block.params[:id])
    end
    render 'momentum_cms/admin/pages/content_blocks', layout: false
  end

  private
  def load_moment_cms_page
    @momentum_cms_page = MomentumCms::Page.find(params[:id])
  end

  def build_moment_cms_page
    @momentum_cms_page = MomentumCms::Page.new(momentum_cms_page_params)
    @momentum_cms_page.site = @current_momentum_cms_site
  end

  def load_parent_pages
    if @momentum_cms_page.new_record?
      @momentum_cms_pages = MomentumCms::Page.all
    else
      @momentum_cms_pages = @current_momentum_cms_site.pages.where.not(id: @momentum_cms_page.subtree_ids)
    end
  end

  def momentum_cms_page_params
    params.fetch(:momentum_cms_page, {}).permit!
  end
end
