class MomentumCms::Admin::DocumentTemplatesController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_document_template, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_document_template, only: [:new, :create]

  def index
    @momentum_cms_document_templates = @current_momentum_cms_site.document_templates.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_document_template.save!
    flash[:success] = 'Document template was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_document_template
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_document_template.update_attributes!(momentum_cms_document_template_params)
    flash[:success] = 'Document template was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_document_template
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_document_template.destroy
    flash[:success] = 'Document template was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_document_template
    @momentum_cms_document_template = MomentumCms::DocumentTemplate.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_moment_cms_document_template
    @momentum_cms_document_template = MomentumCms::DocumentTemplate.new(momentum_cms_document_template_params)
    @momentum_cms_document_template.site = @current_momentum_cms_site
  end

  def momentum_cms_document_template_params
    params.fetch(:momentum_cms_document_template, {}).permit!
  end
end
