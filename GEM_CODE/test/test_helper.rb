# start simplecov
require 'simplecov'
SimpleCov.start 'rails'
ENV['RAILS_ENV'] ||= 'test'

begin
  require 'byebug'
rescue LoadError
end

# require what the gem & tests need
require 'rails'
require 'minitest'
require 'minitest/autorun'
require 'minitest/rg'

# require 'dummy_app/init'
# Bundler.require(*Rails.groups)


# setup correct load path
$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
$:.unshift File.dirname(__FILE__)

# require the gem itself
require './lib/universal_track_manager.rb'


Dir[ ".lib/**/*.rb"].each do |x|
  Dir.glob(File.join(File.dirname(__FILE__), x)) do |c|
    require(c)
    puts "requiring #{c}"
  end
end
