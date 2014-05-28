class MomentumCms::Admin::PagesController < MomentumCms::Admin::BaseController
  before_action :load_momentum_cms_page, only: [:edit, :update, :destroy]
  before_action :build_momentum_cms_page, only: [:new, :create]
  before_action :load_parent_pages, only: [:edit, :new, :update, :create]

  def index
    @momentum_cms_pages = @current_momentum_cms_site.pages.all
    respond_to do |format|
      format.html
      format.js { render js: @momentum_cms_pages.to_json }
    end
  end

  def new
  end

  def edit
    build_momentum_cms_blocks(@momentum_cms_page.template, @momentum_cms_page)
  end

  def create
    @momentum_cms_page.save!
    flash[:success] = 'Page was successfully created.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_blocks(@momentum_cms_page.template, @momentum_cms_page)
    render action: :new
  end

  def update
    @momentum_cms_page.update_attributes!(momentum_cms_page_params)
    flash[:success] = 'Page was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_page
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_blocks(@momentum_cms_page.template, @momentum_cms_page)
    render action: :edit
  end

  def destroy
    @momentum_cms_page.destroy
    flash[:success] = 'Page was successfully destroyed.'
    redirect_to action: :index
  end

  def blocks
    @momentum_cms_page = MomentumCms::Page.where(id: params[:page_id]).first_or_initialize
    @momentum_cms_template = MomentumCms::Template.find(params[:template_id])
    build_momentum_cms_blocks(@momentum_cms_template, @momentum_cms_page)
    render 'momentum_cms/admin/pages/blocks', layout: false
  rescue ActiveRecord::RecordNotFound
    render nothing: true
  end

  private

  def load_parent_pages
    @momentum_cms_parent_pages = @current_momentum_cms_site.pages
    if @momentum_cms_page.persisted?
      @momentum_cms_parent_pages = @momentum_cms_parent_pages.where.not(id: @momentum_cms_page.subtree_ids)
    end
    @momentum_cms_parent_pages
  end

  def load_momentum_cms_page
    @momentum_cms_page = MomentumCms::Page.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_momentum_cms_page
    @momentum_cms_page = MomentumCms::Page.new(momentum_cms_page_params)
    @momentum_cms_page.site = @current_momentum_cms_site
  end

  def momentum_cms_page_params
    params.fetch(:momentum_cms_page, {}).permit!
  end

  def build_momentum_cms_blocks(template, page)
    return unless template && page
    block_templates = TemplateBlockService.new(template).get_blocks
    @block_templates_identifiers = block_templates.collect(&:to_identifier)

    # Get the current page's existing saved blocks
    momentum_cms_blocks = page.blocks

    # Build blocks from each block_templates
    block_templates.each do |block_template|
      unless momentum_cms_blocks.any? { |x| x.identifier == block_template.to_identifier }
        page.blocks.build(
          identifier: block_template.to_identifier,
          block_template_id: block_template.id
        )
      end
    end

  end
end
