site = MomentumCms::Site.where(
  name: 'Test Momentum CMS',
  host: 'localhost:3000'
).first_or_create!

momentum_cms_page_root = MomentumCms::Page.where(
  site: site,
  name: 'Home'
).first_or_create!

['About', 'Contact Us'].each do |page|
  momentum_cms_page = MomentumCms::Page.where(
    site: site,
    name: page
  ).first_or_create!
  momentum_cms_page.move_to_child_of(momentum_cms_page_root)
end

momentum_page_about = MomentumCms::Page.all.to_a.third

['Management', 'Careers'].each do |page|
  momentum_cms_page = MomentumCms::Page.where(
    site: site,
    name: page
  ).first_or_create!
  momentum_cms_page.move_to_child_of(momentum_page_about)
end

MomentumCms::Page.find_each do |page|
  slug      = page.name.downcase.gsub(' ', '-')
  variation = MomentumCms::Variation.where(
    page:    page,
    slug:    slug,
    title:   page.name,
    content: "Lorem Ipsum, this is the content page for #{page.name}"
  )
  variation.create! if variation.first.nil?
end

MomentumCms::Variation.find_each { |variation| variation.send(:assign_path) }