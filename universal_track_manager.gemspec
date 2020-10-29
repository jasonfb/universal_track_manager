

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "version.rb"

Gem::Specification.new do |s|
  s.name        = 'universal-track-manager'
  s.version     = UniversalTrackManager::VERSION
  s.license     = 'MIT'
  s.date        = '2020-10-29'
  s.summary     = "A gem to track visitors to your website."
  s.description = "Simple, plug & play visitor tracking by user agent (browser), IP address, referrer, and UTM parameters."
  s.authors     = ["Jason Fleetwood-Boldt"]
  s.email       = 'jason.fb@datatravels.com'

  all_files       = `git ls-files -z`.split("\x0")

  s.files         = all_files.reject{|x| !x.start_with?('lib')}

  s.require_paths = ["lib"]

  s.homepage    = 'https://blog.jasonfleetwoodboldt.com/universal-track-manager/'
  s.metadata    = { "source_code_uri" => "https://github.com/jasonfb/universal_track_manager" }
  s.add_dependency('rails', '> 4.1')
  s.add_development_dependency('simplecov', '> 0.17')
  s.add_development_dependency('appraisal', '> 2.2')

  s.post_install_message = <<~MSG
    ---------------------------------------------
    Welcome to Universal Track Manager
    to set up, please run
    
    rails generate universal_track_manager:install
    ---------------------------------------------
  MSG
end