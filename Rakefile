# # begin
# #   require 'bundler/setup'
# # rescue LoadError
# #   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# # end
#
# require 'rdoc/task'
#
# RDoc::Task.new(:rdoc) do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title    = 'UniversalTrackManager'
#   rdoc.options << '--line-numbers'
#   rdoc.rdoc_files.include('README.md')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
#
# require 'bundler/gem_tasks'
# require 'rake/testtask'
#
# Rake::TestTask.new(:test) do |t|
#   t.libs << 'test'
#   t.libs << 'test'
#   t.libs << 'lib'
#   t.libs << 'lib/generators'
#   t.libs << 'lib/tasks'
#   t.libs << 'lib/universal_track_manager'
#
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = false
# end
#
# task default: :test
#
#
#
# # desc "Run tests"
# task :default => :test
#
# task :console do
#   require 'irb'
#   require 'irb/completion'
#   require 'universal_track_manager'
#   ARGV.clear
#   IRB.start
# end
#
#


require "rubygems"
require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

namespace :dummy do
  require_relative "spec/dummy/application"
  Dummy::Application.load_tasks
end


desc "Run acceptance specs in spec/lib"
RSpec::Core::RakeTask.new("spec") do |task|
  task.pattern = "spec/lib/**/*_spec.rb"
  task.verbose = false
end

# desc "Run the specs and acceptance tests"
# task default: %w(spec spec:acceptance)