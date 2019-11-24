Gem::Specification.new do |s|
  s.name        = 'universal-track-manager'
  s.version     = '0.0.1'
  s.date        = '2019-11-19'
  s.summary     = "A gem to track your visitors."
  s.description = "See https://github.com/jasonfb/universal_track_manager"
  s.authors     = ["Jason Fleetwood-Boldt"]
  s.email       = 'jason.fb@datatravels.com'
  s.files       = ["lib/universal_track_manager.rb"]
  s.homepage    = 'http://rubygems.org/gems/unverisal-track-manager'
  s.license     = 'MIT'
  s.metadata    = { "source_code_uri" => "https://github.com/jasonfb/universal_track_manager" }

  s.add_dependency('rails')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('appraisal')

end