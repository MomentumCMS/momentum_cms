class MomentumCms::Admin::PagesController < MomentumCms::Admin::BaseController

  before_action :load_momentum_cms_page, only: [:edit, :update, :destroy]
  before_action :build_momentum_cms_page, only: [:new, :create]
  before_action :load_parent_pages, only: [:edit, :new, :update, :create]
  before_action :load_momentum_cms_template, only: [:blocks]

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
    @momentum_cms_template = @momentum_cms_page.template
    build_momentum_cms_blocks
  end

  def create
    @momentum_cms_page.save!
    flash[:success] = 'Page was successfully created.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
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

  def load_momentum_cms_template


  end

  def blocks
    @momentum_cms_page = if params[:page_id]
                           MomentumCms::Page.find(params[:page_id])
                         else
                           MomentumCms::Page.new
                         end

    @momentum_cms_template = if params[:template_id]
                               MomentumCms::Template.find(params[:template_id])
                             else
                               @momentum_cms_page.template
                             end


    build_momentum_cms_blocks

    render 'momentum_cms/admin/pages/blocks', layout: false
  end

  private

  def load_parent_pages
    @momentum_cms_parent_pages = if @momentum_cms_page.persisted?
                                   @current_momentum_cms_site.pages.where.not(id: @momentum_cms_page.subtree_ids)
                                 else
                                   @current_momentum_cms_site.pages
                                 end
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

  def build_momentum_cms_blocks
    # Get all the block templates that is assigned to the template
    @block_templates = TemplateBlockService.new(@momentum_cms_template).get_blocks
    @block_templates_identifiers = @block_templates.collect { |t| "#{t.template.identifier}::#{t.identifier}" }

    # Get the current Content's existing saved blocks
    @momentum_cms_blocks = if @momentum_cms_page
                             @momentum_cms_page.blocks.to_a
                           else
                             []
                           end

    # Build blocks from each block_templates
    @block_templates.each do |block_template|
      if @momentum_cms_blocks.detect { |x| x.identifier == "#{block_template.template.identifier}::#{block_template.identifier}" }.nil?
        @momentum_cms_page.blocks.build(
          identifier: "#{block_template.template.identifier}::#{block_template.identifier}",
          block_template_id: block_template.id
        )
      end
    end
  end
end
