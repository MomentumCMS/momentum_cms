module MomentumCms::AdminHelper

  #-- Content URL Helpers ---------------------------------------------------

  def edit_momentum_content_url(content = nil, page = nil, site = nil)
    content ||= @momentum_cms_content
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    edit_cms_admin_site_page_content_path(site, page, content)
  end

  def new_momentum_content_url(page = nil, site = nil)
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    new_cms_admin_site_page_content_path(site, page)
  end

  def momentum_content_url(content = nil, page = nil, site = nil)
    content ||= @momentum_cms_content
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    cms_admin_site_page_content_path(site, page, content)
  end

  def momentum_contents_url(page = nil, site = nil)
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    cms_admin_site_page_contents_path(site, page)
  end

  #-- Page URL Helpers -------------------------------------------------=====

  def momentum_page_url(page = nil, site = nil)
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    cms_admin_site_page_path(site, page)
  end

  def momentum_pages_url(site = nil)
    site ||= @current_momentum_cms_site
    cms_admin_site_pages_path(site)
  end

  def edit_momentum_page_url(page = nil, site = nil)
    page ||= @momentum_cms_page
    site ||= @current_momentum_cms_site
    edit_cms_admin_site_page_path(site, page)
  end

  def new_momentum_page_url(site = nil)
    site ||= @current_momentum_cms_site
    new_cms_admin_site_page_path(site)
  end

  def momentum_fields_url(site = nil)
    site ||= @current_momentum_cms_site
    fields_cms_admin_site_pages_path(site)
  end
  
  def momentum_fields_url(site = nil)
    site ||= @current_momentum_cms_site
    fields_cms_admin_site_documents_path(site)
  end

end