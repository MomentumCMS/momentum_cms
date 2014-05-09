# desc "Explaining what the task does"
# task :momentum_cms do
#   # Task goes here
# end
namespace :momentum_cms do
  namespace :fixture do
    desc 'Import a site via fixtures'
    task :import => :environment do |t|
      source = ENV['SOURCE']
      if source.blank?
        puts "SOURCE expected, but not provided, run `#{t.name} SOURCE=demo-site`"
        puts "Where:"
        puts "\t SOURCE is a fixture folder under #{MomentumCms.configuration.site_fixtures_path}"
        exit 1
      end
      MomentumCms::Fixture::Importer.new({ from: source }).import!
    end
  end
  namespace :development do
    desc 'Import an example site'
    task :import_example_site => :environment do
      @site = MomentumCms::Site.where(label: 'Example Site', host: 'localhost', identifier: 'example-a').first_or_create!
      MomentumCms::Fixture::Template::Importer.new('example-a', @site).import!
      MomentumCms::Fixture::Page::Importer.new('example-a', @site).import!
      MomentumCms::Page.find_each do |page|
        content = MomentumCms::Content.where(
          page: page,
          label: "#{page.label}-#{I18n.locale}",
          content: "Lorem Ipsum, this is the content page for #{page.label}-#{I18n.locale}"
        )
        content = if content.first.nil?
                    content.create!
                  else
                    content.first!
                  end
        [:en, :fr, :es].each do |locale|
          I18n.locale = locale
          content.label = "#{page.label}-#{I18n.locale}"
          content.content = "Lorem Ipsum, this is the content page for #{page.label}-#{I18n.locale}"
          content.save!
        end
        MomentumCms::Page.order(:id).to_a.each do |p|
          p.save
        end
      end
    end
  end
end
