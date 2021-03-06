source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.4.4'

# Can remove this after ruby 2.4*
gem 'no_proxy_fix'

gem 'vault', '~> 0.15.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3.0'
gem 'pg', '0.20'
gem 'activerecord-import', '1.0.3'

gem 'rest-client', '>= 1.8.0'

gem 'simple-navigation'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.2'

gem 'jquery-rails'
gem 'jquery-datatables-rails', '~> 3.3.0'
gem 'turbolinks'

# Pulled in by other things, pinned for security advisories.
gem 'sprockets', '>= 3.7.2'
gem 'rubocop', '>= 0.49.0'
gem 'rails-html-sanitizer', '>= 1.0.4'
gem 'ffi', '>= 1.9.24'
gem 'loofah', '>= 2.3.1'
gem 'nokogiri', '>= 1.10.8'
gem 'rack', '~> 2.0', '>= 2.1.3'
gem 'websocket-extensions', '>= 0.1.5'

gem 'whenever', :require => false

gem 'puppetdb-ruby'
gem 'httparty', '~> 0.17.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'dlss_cops'
end

group :test do
  gem 'coveralls', require: false
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rails-controller-testing'
end

# Use Capistrano for deployment
group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails' # or other gems as appropriate
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'dlss-capistrano'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
