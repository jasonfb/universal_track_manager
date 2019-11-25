

Dir[ "lib/**/*.rb"].each do |x|
  Dir.glob(File.join(File.dirname(__FILE__), x)) do |c|
    puts "requiring #{c}"
    require(c)
  end
end

module UniversalTrackManager
  require "railtie.rb" if defined?(Rails)
end

