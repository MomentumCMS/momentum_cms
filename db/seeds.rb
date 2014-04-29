site = MomentumCms::Site.where(
  label: 'Test Momentum CMS',
  host:  'localhost:3000'
).first_or_create!

momentum_cms_page_root = MomentumCms::Page.where(
  site:  site,
  label: 'Home',
  slug:  '/'
).first_or_create!

['About', 'Contact Us'].each do |page|
  momentum_cms_page = MomentumCms::Page.where(
    site:  site,
    label: page,
    slug:  page.downcase.gsub(' ', '-')
  ).first_or_create! do |o|
    o.parent = momentum_cms_page_root
  end
end

momentum_page_about = MomentumCms::Page.all.to_a.third

['Management', 'Careers'].each do |page|
  momentum_cms_page = MomentumCms::Page.where(
    site:  site,
    label: page,
    slug:  page.downcase.gsub(' ', '-')
  ).first_or_create! do |o|
    o.parent = momentum_page_about
  end
end

MomentumCms::Page.find_each do |page|
  variation = MomentumCms::Content.where(
    page:    page,
    label:   page.label,
    content: "Lorem Ipsum, this is the content page for #{page.label}"
  )
  variation.create! if variation.first.nil?
end

MomentumCms::Page.order(:id).to_a.each do |p|
  p.save
end