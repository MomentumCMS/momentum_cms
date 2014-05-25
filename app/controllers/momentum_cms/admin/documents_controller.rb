class MomentumCms::Admin::DocumentsController < MomentumCms::Admin::BaseController
  before_action :load_momentum_cms_document_template

  before_action :load_moment_cms_document, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_document, only: [:new, :create]


  def index
    @momentum_cms_documents = @momentum_cms_document_template.documents.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_document.save!
    flash[:success] = 'Document was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_document
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
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

  private
  def load_momentum_cms_document_template
    @momentum_cms_document_template = MomentumCms::DocumentTemplate.find(params[:document_template_id])
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
    # @momentum_cms_document.site = @current_momentum_cms_site
  end

  def momentum_cms_document_params
    params.fetch(:momentum_cms_document, {}).permit!
  end
end
