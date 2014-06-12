class MomentumCms::Admin::PagesController < MomentumCms::Admin::BaseController
  before_action :load_momentum_cms_page, only: [:edit, :update, :destroy, :publish, :unpublish]
  before_action :build_momentum_cms_page, only: [:new, :create]
  before_action :load_parent_pages, only: [:edit, :new, :update, :create]

  def index
    @momentum_cms_pages = @current_momentum_cms_site.pages
    respond_to do |format|
      format.html
      format.js { render js: @momentum_cms_pages.to_json }
    end
  end

  def unpublish
    @momentum_cms_page.unpublish!
    flash[:success] = 'Page was successfully unpublished.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  end

  def publish
    @momentum_cms_page.publish!
    flash[:success] = 'Page was successfully published.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  end

  def new
  end

  def edit
    build_momentum_cms_fields(@momentum_cms_page.template, @momentum_cms_page)
  end

  def create
    @momentum_cms_page.save!
    flash[:success] = 'Page was successfully created.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_fields(@momentum_cms_page.template, @momentum_cms_page)
    render action: :new
  end

  def update
    @momentum_cms_page.update_attributes!(momentum_cms_page_params)
    flash[:success] = 'Page was successfully updated.'
    redirect_to action: :edit, id: @momentum_cms_page
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_fields(@momentum_cms_page.template, @momentum_cms_page)
    render action: :edit
  end

  def destroy
    @momentum_cms_page.destroy
    flash[:success] = 'Page was successfully destroyed.'
    redirect_to action: :index
  end

  def fields
    @momentum_cms_page = MomentumCms::Page.where(id: params[:page_id]).first_or_initialize
    @momentum_cms_template = MomentumCms::Template.find(params[:template_id])
    build_momentum_cms_fields(@momentum_cms_template, @momentum_cms_page)
    render 'momentum_cms/admin/pages/fields', layout: false
  rescue ActiveRecord::RecordNotFound
    render nothing: true
  end

  private

  def load_parent_pages
    @momentum_cms_parent_pages = @current_momentum_cms_site.pages
    if @momentum_cms_page.persisted?
      @momentum_cms_parent_pages = @momentum_cms_parent_pages.where.not(id: @momentum_cms_page.subtree_ids)
    end
  end

  def load_momentum_cms_page
    @momentum_cms_page = MomentumCms::Page.find(params[:id])
    @momentum_cms_page_revisions = @momentum_cms_page.revisions
    revision = @momentum_cms_page_revisions.where(revision_number: params.fetch(:revision, nil)).first
    if revision
      @momentum_cms_page_revision_data = revision.revision_data
    end
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

  def build_momentum_cms_fields(template, page)
    return unless template && page
    layout_field_service = LayoutFieldService.new(template)
    @field_templates_identifiers = layout_field_service.get_identifiers
    layout_field_service.build_momentum_cms_field(page, @momentum_cms_page_revision_data)
  end
end
