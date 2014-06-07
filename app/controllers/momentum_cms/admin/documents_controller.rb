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
    revision_number = params.fetch(:revision, nil)
    if revision_number
      revision = @momentum_cms_document_revisions.where(revision_number: revision_number).first
      if revision
        @momentum_cms_document_revision_data = revision.revision_data
      end
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
    field_templates = DocumentFieldService.new(blue_print).get_fields
    @field_templates_identifiers = field_templates.collect(&:to_identifier)

    if @momentum_cms_document_revision_data
      # Get the current document's existing saved fields
      momentum_cms_fields = document.fields.draft_fields

      field_revisions = @momentum_cms_document_revision_data[:fields]
      field_translation_revisions = @momentum_cms_document_revision_data[:fields_translations]

      momentum_cms_fields.each do |field|
        field_revision = field_revisions.detect do |x|
          x['identifier'] == field.identifier
        end

        if field_revision
          translation_for_field = field_translation_revisions.find do |x|
            x['momentum_cms_field_id'] == field_revision['id'] && x['locale'] == I18n.locale.to_s
          end

          if translation_for_field
            field.value = translation_for_field['value']
            field.save
          else
            field.translations.where(locale: I18n.locale).destroy_all
          end
        else
          field.destroy
        end
      end

      momentum_cms_fields = document.fields.draft_fields.reload
      field_revisions.each do |field_revision|
        field = momentum_cms_fields.where(field_template: field_revision['field_template_id'],
                                          identifier: field_revision['identifier']).first_or_initialize
        if field.new_record?
          field.save
          translation_for_field = field_translation_revisions.find do |x|
            x['momentum_cms_field_id'] == field_revision['id'] && x['locale'] == I18n.locale.to_s
          end
          if translation_for_field
            field.value = translation_for_field['value']
            field.save
          end
        end
      end
    end

    momentum_cms_fields = document.fields.draft_fields
    # Build fields from each field_templates
    field_templates.each do |field_template|
      field = momentum_cms_fields.detect { |x| x.identifier == field_template.to_identifier && x.field_type == 'draft' }
      if field.nil?
        document.fields.build(
            identifier: field_template.to_identifier,
            field_template_id: field_template.id
        )
      end
    end
  end
end
