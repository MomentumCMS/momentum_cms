class MomentumCms::Admin::DocumentsController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_document, only: [:edit, :update, :destroy, :publish, :unpublish]
  before_action :build_moment_cms_document, only: [:new, :create]

  def index
    @momentum_cms_documents = @current_momentum_cms_site.documents.all
  end

  def unpublish
    @momentum_cms_document.unpublish!
    flash[:success] = 'Document was successfully unpublished.'
    redirect_to edit_cms_admin_site_document_path(@current_momentum_cms_site, @momentum_cms_document)
  end

  def publish
    @momentum_cms_document.publish!
    flash[:success] = 'Document was successfully published.'
    redirect_to edit_cms_admin_site_document_path(@current_momentum_cms_site, @momentum_cms_document)
  end

  def new
  end

  def edit
    build_momentum_cms_fields(@momentum_cms_document.blue_print, @momentum_cms_document)
  end

  def create
    @momentum_cms_document.save!
    flash[:success] = 'Document was successfully created.'
    redirect_to action: :edit, id: @momentum_cms_document
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_fields(@momentum_cms_document.blue_print, @momentum_cms_document)
    render action: :new
  end

  def update
    @momentum_cms_document.update_attributes!(momentum_cms_document_params)
    flash[:success] = 'Document was successfully updated.'
    redirect_to action: :edit, id: @momentum_cms_document
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_fields(@momentum_cms_document.blue_print, @momentum_cms_document)
    render action: :edit
  end

  def destroy
    @momentum_cms_document.destroy
    flash[:success] = 'Document was successfully destroyed.'
    redirect_to action: :index
  end

  def fields
    @momentum_cms_document = MomentumCms::Document.where(params[:document_id]).first_or_initialize
    @momentum_cms_blue_print = MomentumCms::BluePrint.find(params[:blue_print_id])
    build_momentum_cms_fields(@momentum_cms_blue_print, @momentum_cms_document)
    render 'momentum_cms/admin/documents/fields', layout: false
  rescue ActiveRecord::RecordNotFound
    render nothing: true
  end

  private

  def load_moment_cms_document
    @momentum_cms_document = MomentumCms::Document.find(params[:id])
    @momentum_cms_document_revisions = @momentum_cms_document.revisions
    revision = @momentum_cms_document_revisions.where(revision_number: params.fetch(:revision, nil)).first
    if revision
      @momentum_cms_document_revision_data = revision.revision_data
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_moment_cms_document
    @momentum_cms_document = MomentumCms::Document.new(momentum_cms_document_params)
    @momentum_cms_document.site = @current_momentum_cms_site
  end

  def momentum_cms_document_params
    params.fetch(:momentum_cms_document, {}).permit!
  end

  def build_momentum_cms_fields(blue_print, document)
    return unless blue_print && document
    layout_field_service = LayoutFieldService.new(blue_print)
    @field_templates_identifiers = layout_field_service.get_identifiers
    layout_field_service.build_momentum_cms_field(document, @momentum_cms_document_revision_data)
  end
end
