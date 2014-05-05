class MomentumCms::Admin::BaseController < ApplicationController
  layout 'momentum_cms/admin/application'

  before_action :load_sites

  def load_sites
    @momentum_cms_sites = MomentumCms::Site.all
  end
end
