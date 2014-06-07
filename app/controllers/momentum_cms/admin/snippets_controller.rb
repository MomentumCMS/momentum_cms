class MomentumCms::Admin::SnippetsController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_snippet, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_snippet, only: [:new, :create]

  def index
    @momentum_cms_snippets = @current_momentum_cms_site.snippets.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_snippet.save!
    flash[:success] = 'Snippet was successfully created.'
    redirect_to action: :edit, id: @momentum_cms_snippet
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_snippet.update_attributes!(momentum_cms_snippet_params)
    flash[:success] = 'Snippet was successfully updated.'
    redirect_to action: :edit, id: @momentum_cms_snippet
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_snippet.destroy
    flash[:success] = 'Snippet was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_snippet
    @momentum_cms_snippet = MomentumCms::Snippet.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_moment_cms_snippet
    @momentum_cms_snippet = MomentumCms::Snippet.new(momentum_cms_snippet_params)
    @momentum_cms_snippet.site = @current_momentum_cms_site
  end

  def momentum_cms_snippet_params
    params.fetch(:momentum_cms_snippet, {}).permit!
  end
end
