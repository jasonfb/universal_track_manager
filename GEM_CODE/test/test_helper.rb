# start simplecov
require 'simplecov'
SimpleCov.start 'rails'
ENV['RAILS_ENV'] ||= 'test'

begin
  require 'byebug'
rescue LoadError
end


# require "./test/dummy_app/config/environment"
# require "rails/test_help"
# require what the gem & tests need
require 'minitest'
require 'minitest/autorun'
require 'minitest/rg'

require "minitest/unit"
require "mocha/minitest"
#
#
require 'rails'
# require 'rspec/rails'
# require './test/dummy_app/spec/rails_helper.rb'
# require './test/dummy_app/spec/spec_helper.rb'

# setup correct load path
$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
$:.unshift File.dirname(__FILE__)

# require the gem itself
require './lib/universal_track_manager.rb'

# Dir[ "./test/lib/*.rb",
#      "./test/support/*.rb",
#      "./test/test_helper.rb"].each do |x|
#   puts "requiring #{x}"
#   require(x)
#
#
# end

Dir["./test/support/**/*.rb"].each do |f|
  require f
  puts "requiring #{f}"
end
#
# Dir[ "./test/**/*"].each do |x|
#   puts "#{x}"
#   Dir.glob(File.join(File.dirname(__FILE__), x)) do |c|
#     require(c)
#     puts "requiring #{c}"
#     end
# end


# ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../../test/dummy"