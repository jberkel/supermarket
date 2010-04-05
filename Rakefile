require 'warbler'
require 'rake/clean'
CLEAN.include('pkg', 'tmp')

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

warbler = Warbler::Task.new


war_dir = "tmp/war"
directory war_dir

task :explode => [:clean, :war, war_dir] do
  sh "unzip #{warbler.config.war_name}.war -d #{war_dir}"
end

desc "deploy to gae"
task :deploy => [:explode] do
  #TODO: call java directly
  sh "appcfg.sh update #{war_dir}"
end


namespace :bundle do
  task :install do
    sh "jruby -S bundle install vendor/gems --disable-shared-gems"
  end
end
