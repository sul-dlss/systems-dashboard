source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'pg'
gem 'activerecord-import'

gem 'rest-client', '>= 1.8.0'

gem 'simple-navigation'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'nokogiri', '>= 1.6.8'
gem 'jquery-rails'
gem 'jquery-datatables-rails', '~> 3.3.0'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'whenever', :require => false

gem 'puppetdb-ruby'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'dlss_cops'
end

group :test do
  gem 'coveralls', require: false
  gem 'shoulda-matchers', '~> 3.1'
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
