class MomentumCms::Api::DocumentsController < MomentumCms::Api::BaseController
  before_action :load_moment_cms_documents, only: [:index]
  before_action :load_moment_cms_document, only: [:show]

  def index
    render json: @momentum_cms_documents
  end

  def show
    render json: @momentum_cms_document
  end

  private

  def load_moment_cms_documents
    @momentum_cms_documents = MomentumCms::Document.all
  end

  def load_moment_cms_document
    @momentum_cms_document = MomentumCms::Document.find(params[:id])
  end

  def momentum_cms_document_params
    params[:momentum_cms_document]
  end
end
