RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      # DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      # DatabaseCleaner.clean
    end
  end
end
FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), '..', 'factories')
FactoryGirl.find_definitions
