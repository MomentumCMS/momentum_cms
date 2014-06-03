class MomentumCms::Admin::DocumentsController < MomentumCms::Admin::BaseController

  before_action :load_moment_cms_document, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_document, only: [:new, :create]

  def index
    @momentum_cms_documents = @current_momentum_cms_site.documents.all
  end

  def new
  end

  def edit
    build_momentum_cms_fields(@momentum_cms_document.blue_print, @momentum_cms_document)
  end

  def create
    @momentum_cms_document.save!
    flash[:success] = 'Document was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_document
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_fields(@momentum_cms_document.blue_print, @momentum_cms_document)
    render action: :new
  end

  def update
    @momentum_cms_document.update_attributes!(momentum_cms_document_params)
    flash[:success] = 'Document was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_document
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
    # Get all the field templates that is assigned to the document template
    field_templates = DocumentFieldService.new(blue_print).get_fields
    @field_templates_identifiers = field_templates.collect(&:to_identifier)

    # Get the current document's existing saved fields
    momentum_cms_fields = document.fields

    # Build fields from each field_templates
    field_templates.each do |field_template|
      unless momentum_cms_fields.any? { |x| x.identifier == field_template.to_identifier }
        document.fields.build(
          identifier: field_template.to_identifier,
          field_template_id: field_template.id
        )
      end
    end
  end

end
