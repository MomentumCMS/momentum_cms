site = MomentumCms::Site.where(
  label: 'Test Momentum CMS',
  host:  'localhost:3000'
).first_or_create!

[:en, :fr, :es].each do |locale|

  I18n.locale = locale

  momentum_cms_page_root = MomentumCms::Page.where(
    site:  site,
    label: 'Home'
  ).first_or_create!

  momentum_cms_page_root.slug="home-#{I18n.locale}"
  momentum_cms_page_root.save

  ['About', 'Contact Us'].each do |page|
    momentum_cms_page = MomentumCms::Page.where(
      site:  site,
      label: page,
    ).first_or_create! do |o|
      o.parent = momentum_cms_page_root
    end

    momentum_cms_page.slug = "#{page.downcase.gsub(' ', '-')}-#{I18n.locale}"
    momentum_cms_page.save
  end

  momentum_page_about = MomentumCms::Page.all.to_a.third

  ['Management', 'Careers'].each do |page|
    momentum_cms_page = MomentumCms::Page.where(
      site:  site,
      label: page
    ).first_or_create! do |o|
      o.parent = momentum_page_about
    end

    momentum_cms_page.slug = "#{page.downcase.gsub(' ', '-')}-#{I18n.locale}"
    momentum_cms_page.save
  end

  MomentumCms::Page.find_each do |page|
    content = MomentumCms::Content.where(
      page:    page,
      label:   "#{page.label}-#{I18n.locale}",
      content: "Lorem Ipsum, this is the content page for #{page.label}-#{I18n.locale}"
    )
    content.create! if content.first.nil?
  end

  MomentumCms::Page.order(:id).to_a.each do |p|
    p.save
  end

end
