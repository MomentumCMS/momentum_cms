class MomentumCms::VariationsController < MomentumCms::BasesController
  before_action :load_momentum_cms_variation, only: [:show]

  def show
    render
  end

  private
  def load_momentum_cms_variation
    path = "/#{params[:id]}" || '/'

    @momentum_cms_variation = MomentumCms::Variation.where(path: path).first!
  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::RecordNotFound.new(path)
  end
end
