
require 'rake/clean'
CLEAN.include('pkg')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "supermarket"
    gem.summary = "JRuby bindings for android-market-api"
    gem.email = "jan.berkel@gmail.com"
    gem.homepage = "http://github.com/jberkel/supermarket"
    gem.description = "An unoffical/reverse engineered API for Android market."
    gem.authors = ["Jan Berkel"]
    gem.files = FileList['lib/**/*', 'bin/*'].to_a
    gem.executables = "market"
    gem.platform = 'universal-java'
    gem.add_dependency "json-jruby"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
