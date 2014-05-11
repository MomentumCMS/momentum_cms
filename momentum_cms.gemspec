$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "momentum_cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "momentum_cms"
  s.version     = MomentumCms::VERSION
  s.authors     = ['Emerson', 'Bill']
  s.email       = ['emerson@twg.ca', 'bill@twg.ca']
  s.homepage    = 'https://github.com/MomentumCMS/momentum_cms'
  s.summary     = 'MomentumCms is a Content Management System'
  s.description = 'MomentumCms is a Content Management System.'
  s.license     = 'MIT'
  
  s.files         = `git ls-files`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'

  s.add_dependency 'rails',                    '~> 4.0.0'
  s.add_dependency 'awesome_nested_set',       '~> 3.0.0.rc.3'
  s.add_dependency 'ancestry',                 '~> 2.1.0'
  s.add_dependency 'globalize',                '~> 4.0.1'
  s.add_dependency 'haml-rails',               '~> 0.4'
  s.add_dependency 'sass-rails',               '~> 4.0.3'
  s.add_dependency 'paper_trail',              '~> 3.0.1'
  s.add_dependency 'globalize-versioning',     '~> 0.1.0.alpha.1'
  s.add_dependency 'paperclip',                '~> 4.1.1'
  s.add_dependency 'jquery-rails',             '~> 3.1.0'
  s.add_dependency 'simple_form',              '~> 3.1.0.rc1'
  s.add_dependency 'liquid',                   '~> 2.6.1'
end
