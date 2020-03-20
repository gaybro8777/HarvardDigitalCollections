# # frozen_string_literal: true

# require 'rubygems'
# require 'rails'
# begin
#   require 'bundler/setup'
# rescue LoadError
#   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# end

# Bundler::GemHelper.install_tasks

# load "tasks/blacklight.rake"
# load "lib/railties/blacklight.rake"

# task default: [:rubocop, :ci]

# =====DELETE THIS AND ABOVE=======

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'solr_wrapper/rake_task' unless Rails.env.production?
