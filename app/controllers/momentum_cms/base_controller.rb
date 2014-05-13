class MomentumCms::BaseController < ApplicationController
  rescue_from MomentumCms::RecordNotFound, with: :error_render_method
  rescue_from MomentumCms::SiteNotFound, with: :error_render_method

  before_action :load_site
  before_action :set_locale

  private

  def set_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || params[:locale] || :en
  end
  def load_site
    @momentum_cms_site = MomentumCms::Site.where(host: request.host_with_port).first
    unless @momentum_cms_site
      @momentum_cms_site = MomentumCms::Site.first!
    end
  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::SiteNotFound.new(request.host_with_port)
  end

  def error_render_method(exception)
    @exception = exception
    respond_to do |type|
      type.html { render template: 'momentum_cms/errors/404', layout: 'application', status: 404 }
      type.all { render nothing: true, status: 404 }
    end
    true
  end
end
