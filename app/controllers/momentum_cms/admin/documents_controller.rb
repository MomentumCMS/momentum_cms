class MomentumCms::Admin::DocumentsController < MomentumCms::Admin::BaseController

  before_action :load_moment_cms_document, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_document, only: [:new, :create]
  before_action :load_momentum_cms_document_template, only: [:fields]

  def index
    @momentum_cms_documents = @current_momentum_cms_site.documents.all
  end

  def new
  end

  def edit
    @momentum_cms_document_template = @momentum_cms_document.document_template
    build_momentum_cms_fields
  end

  def create
    @momentum_cms_document.save!
    flash[:success] = 'Document was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_document
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_document_template = @momentum_cms_document.document_template
    build_momentum_cms_fields
    @momentum_cms_document.update_attributes!(momentum_cms_document_params)
    flash[:success] = 'Document was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_document
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_document.destroy
    flash[:success] = 'Document was successfully destroyed.'
    redirect_to action: :index
  end


  def fields
    @momentum_cms_document = if params[:document_id]
                               MomentumCms::Document.find(params[:document_id])
                             else
                               MomentumCms::Document.new
                             end

    @momentum_cms_document_template = if params[:document_template_id]
                                        MomentumCms::DocumentTemplate.find(params[:document_template_id])
                                      else
                                        @momentum_cms_document.document_template
                                      end

    build_momentum_cms_fields

    render 'momentum_cms/admin/documents/fields', layout: false
  end

  private
  def load_momentum_cms_document_template
    @momentum_cms_document_template = if params[:document_template_id]
                                        MomentumCms::DocumentTemplate.where(id: params[:document_template_id]).first!
                                      elsif @momentum_cms_document
                                        @momentum_cms_document.document_template
                                      end


  rescue ActiveRecord::RecordNotFound
    redirect_to [:cms, :admin, :site, :document_templates]
  end

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


  def build_momentum_cms_fields

    # Get all the block templates that is assigned to the template
    @field_templates = @momentum_cms_document_template.field_templates

    @field_templates_identifiers = @field_templates.collect { |t| "#{t.document_template.identifier}::#{t.identifier}" }

    # Get the current Content's existing saved blocks
    @momentum_cms_fields = if @momentum_cms_document
                             @momentum_cms_document.fields.to_a
                           else
                             []
                           end

    # Build blocks from each field_templates
    @field_templates.each do |field_template|
      if @momentum_cms_fields.detect { |x| x.identifier == "#{field_template.document_template.identifier}::#{field_template.identifier}" }.nil?
        @momentum_cms_document.fields.build(
          identifier: "#{field_template.document_template.identifier}::#{field_template.identifier}",
          field_template_id: field_template.id
        )
      end
    end
  end
end
