# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'codeclimate-test-reporter'
require 'simplecov'
require 'coveralls'
require 'json'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
]
CodeClimate::TestReporter.start

SimpleCov.start 'rails' do
  add_group 'Tags', 'lib/momentum_cms/tags'
  add_group 'Services', 'app/services'
end

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
ActiveSupport::TestCase.fixture_path = File.expand_path('../fixtures', __FILE__)

class ActiveSupport::TestCase
  fixtures :all
  include ActionDispatch::TestProcess

  #Allows to assert on the number of SQL statement used
  def asset_query_count_equal(count, &block)
    @counter = ActiveRecord::QueryCounter.new
    ActiveSupport::Notifications.subscribe('sql.active_record', @counter.to_proc)
    yield
    ActiveSupport::Notifications.unsubscribe(@counter.to_proc)
    assert_equal @counter.query_count, count, "Expected to execute in #{count} SQL statements, but used #{@counter.query_count}"
  end

  def json_response
    JSON.parse(response.body)
  end

  def setup_test_site
    @site = momentum_cms_sites(:default)
    @site.save!
    @site.reload
    @request.host = @site.host

    @parent_content = momentum_cms_contents(:default)
    @parent_content.label = 'default'
    @parent_content.save!
    @parent_content.reload

    @child_content = momentum_cms_contents(:child)
    @child_content.label = 'child'
    @child_content.save!
    @child_content.reload

    @parent_template = momentum_cms_templates(:default)
    @child_template = momentum_cms_templates(:child)
    @child_template.parent = @parent_template
    @child_template.save

    @default_page = momentum_cms_pages(:default)
    @default_page.slug = '/'
    @default_page.site = @site
    @default_page.update_attribute(:published_content_id, @parent_content.id)
    @default_page.save!
    @default_page.reload

    @child_page = momentum_cms_pages(:child)
    @child_page.slug = 'child'
    @child_page.site = @site
    @child_page.parent = @parent_page
    @child_page.update_attribute(:published_content_id, @child_content.id)
    @child_page.save!
    @child_page.reload
  end

end