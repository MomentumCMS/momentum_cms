class MomentumCms::PagesController < ApplicationController
  before_action :load_momentum_cms_page, only: [:show]

  # GET /momentum_cms/pages/1
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def load_momentum_cms_page
    @momentum_cms_page = MomentumCms::Page.where(:slug => params[:path]).first
    
  end

end
