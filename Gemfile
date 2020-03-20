source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", '>= 5.1', '< 7'
gem 'mysql2'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# gem 'pg', '~> 0.20'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'blacklight', '~> 6.20'
group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end

gem 'rsolr', '>= 1.0'
gem 'jquery-rails'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'blacklight-marc', '~> 6.1'
gem 'blacklight-gallery', '~> 0.11.0'
gem 'blacklight_range_limit', '~> 6.3.3'
gem 'foundation-rails', '~> 5.4'
gem 'font-awesome-sass'
gem 'jsonpath', '1.0.1'



# # frozen_string_literal: true

# source 'https://rubygems.org'

# # Please see blacklight.gemspec for dependency information.
# gemspec path: File.expand_path('..', __FILE__)

# group :test do
#   gem 'activerecord-jdbcsqlite3-adapter', platform: :jruby
# end

# # BEGIN ENGINE_CART BLOCK
# # engine_cart: 0.10.0
# # engine_cart stanza: 0.10.0
# # the below comes from engine_cart, a gem used to test this Rails engine gem in the context of a Rails app.
# file = File.expand_path('Gemfile', ENV['ENGINE_CART_DESTINATION'] || ENV['RAILS_ROOT'] || File.expand_path('.internal_test_app', File.dirname(__FILE__)))
# if File.exist?(file)
#   begin
#     eval_gemfile file
#   rescue Bundler::GemfileError => e
#     Bundler.ui.warn '[EngineCart] Skipping Rails application dependencies:'
#     Bundler.ui.warn e.message
#   end
# else
#   Bundler.ui.warn "[EngineCart] Unable to find test application dependencies in #{file}, using placeholder dependencies"

#   if ENV['RAILS_VERSION']
#     if ENV['RAILS_VERSION'] == 'edge'
#       gem 'rails', github: 'rails/rails'
#       ENV['ENGINE_CART_RAILS_OPTIONS'] = '--edge --skip-turbolinks'
#     else
#       gem 'rails', ENV['RAILS_VERSION']
#     end
#   end

#   case ENV['RAILS_VERSION']
#   when /^5.[12]/, /^6.0/
#     gem 'sass-rails', '~> 5.0'
#   when /^4.2/
#     gem 'responders', '~> 2.0'
#     gem 'sass-rails', '>= 5.0'
#     gem 'coffee-rails', '~> 4.1.0'
#     gem 'json', '~> 1.8'
#   when /^4.[01]/
#     gem 'sass-rails', '< 5.0'
#   end
# end
# # END ENGINE_CART BLOCK

# eval_gemfile File.expand_path("spec/test_app_templates/Gemfile.extra", File.dirname(__FILE__))
