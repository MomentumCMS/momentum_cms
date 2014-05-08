# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start 'rails' do
  add_group 'Tags', 'lib/momentum_cms/tags'
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

  #Allows to assert on the number of SQL statement used
  def asset_query_count_equal(count, &block)
    @counter = ActiveRecord::QueryCounter.new
    ActiveSupport::Notifications.subscribe('sql.active_record', @counter.to_proc)
    yield
    ActiveSupport::Notifications.unsubscribe(@counter.to_proc)
    assert_equal @counter.query_count, count, "Expected to execute in #{count} SQL statements, but used #{@counter.query_count}"
  end
end