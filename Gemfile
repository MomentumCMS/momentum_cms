source "https://rubygems.org"

# Declare your gem's dependencies in momentum_cms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

group :development, :test do
  gem 'simplecov', '~> 0.8.2',      require: false
  gem 'coveralls',                  require: false
  gem 'codeclimate-test-reporter',  require: nil
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'

  gem 'database_cleaner',   '~> 1.3.0'
  gem 'rspec-rails',        '~> 3.0.1'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'capybara',           '~> 2.3.0'
end
