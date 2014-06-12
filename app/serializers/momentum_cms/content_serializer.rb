class MomentumCms::ContentSerializer < MomentumCms::ApplicationSerializer

  #-- Attributes ------------------------------------------------------------
  attributes :id, :default, :page, :template, :site, :html_content

  #-- Associations ----------------------------------------------------------
  has_many :fields

  #-- Methods ---------------------------------------------------------------
  def page
    object.page
  end

  def template
    object.page.template
  end

  def site
    object.page.site
  end

  def html_content
    content = nil
    template_array(template).reverse.each do |t|
      liquid = Liquid::Template.parse(t.value)
      content = liquid.render(yield: content,
                              cms_template: t,
                              cms_site: site,
                              cms_page: page,
                              cms_content: object)
    end
    content
  end

  def template_array(template)
    MomentumCms::Template.for_site(site).ancestor_and_self!(template)
  end

end
