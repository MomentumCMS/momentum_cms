# desc "Explaining what the task does"
# task :momentum_cms do
#   # Task goes here
# end
namespace :momentum_cms do
  namespace :remote_fixture do
    desc 'Import a site via remote fixtures'
    task :import => :environment do |t|
      source = ENV['SOURCE']
      site = ENV['SITE']

      if source.blank?
        puts "SOURCE expected, but not provided, run `#{t.name} SOURCE=www.example.com/site.json`"
        puts "Where:"
        puts "\t SOURCE is a remote fixture"
        exit 1
      end
      MomentumCms::RemoteFixture::Importer.new({ source: source, site: site }).import!
    end
  end

  namespace :fixture do
    desc 'Import a site via fixtures'
    task :import => :environment do |t|
      source = ENV['SOURCE']
      site = ENV['SITE']

      if source.blank?
        puts "SOURCE expected, but not provided, run `#{t.name} SOURCE=demo-site`"
        puts "Where:"
        puts "\t SOURCE is a fixture folder under #{MomentumCms.configuration.site_fixtures_path}"
        exit 1
      end
      MomentumCms::Fixture::Importer.new({ source: source, site: site }).import!
    end

    desc 'Export a site to fixtures'
    task :export => :environment do |t|
      site = ENV['SITE']
      target = ENV['TARGET']
      if target.blank? || site.blank?
        puts "SITE and TARGET expected, but not provided, run `#{t.name} TARGET=demo-site SITE=demo-site`"
        puts "Where:"
        puts "\t TARGET is a fixture folder under #{MomentumCms.configuration.site_fixtures_path}"
        puts "\t SITE is a site with in the application, identified by the unique identifier"
        exit 1
      end
      MomentumCms::Fixture::Exporter.new({ target: target, site: site }).export!
    end

  end
end
