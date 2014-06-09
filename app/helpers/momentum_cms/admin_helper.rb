module MomentumCms::AdminHelper

  # == Page URL Helpers =====================================================

  def momentum_page_path(page = nil, site = nil)
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    cms_admin_site_page_path(site, page)
  end

  def momentum_pages_path(site = nil)
    site ||= @current_momentum_cms_site
    cms_admin_site_pages_path(site)
  end

  def edit_momentum_page_path(page = nil, site = nil)
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    edit_cms_admin_site_page_path(site, page)
  end

  def new_momentum_page_path(site = nil)
    site ||= @current_momentum_cms_site
    new_cms_admin_site_page_path(site)
  end

  def momentum_fields_path_for(object, site = nil)
    site ||= @current_momentum_cms_site
    case object
      when MomentumCms::Page
        fields_cms_admin_site_pages_path(site)
      when MomentumCms::Document
        fields_cms_admin_site_documents_path(site)
      else
        raise "#{object.class.name} does not have fields"
    end
  end

end