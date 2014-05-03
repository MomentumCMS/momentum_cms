# desc "Explaining what the task does"
# task :momentum_cms do
#   # Task goes here
# end
namespace :momentum_cms do
  namespace :development do
    desc 'Import an example site'
    task :import_example_site => :environment do
      @pages_path = File.join('example-a', 'pages')
      @site       = MomentumCms::Site.create(label: 'Import', host: 'localhost')
      MomentumCms::Fixture::Page::Importer.new(@site, @pages_path).import!
    end
  end
end