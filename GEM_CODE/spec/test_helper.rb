# # start simplecov
# require 'simplecov'
# SimpleCov.start 'rails'
# ENV['RAILS_ENV'] ||= 'test'
#
# begin
#   require 'byebug'
# rescue LoadError
# end
#
# require 'minitest'
# require 'minitest/autorun'
# require 'minitest/rg'
# require "minitest/unit"
# require "mocha/minitest"
# require 'rails'
#
#
# # setup correct load path
# $LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
# $LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
# $:.unshift File.dirname(__FILE__)
#
# # require the gem itself
# require './lib/universal_track_manager.rb'
#
#
# Dir["./test/support/**/*.rb"].each do |f|
#   require f
#   puts "requiring #{f}"
# end
