require 'warbler'
require 'rake/clean'
CLEAN.include('pkg', 'tmp')

APPENGINE_WEB_XML = "appengine-web.xml"
war_dir = "tmp/war"
directory war_dir

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

task :explode => [:clean, :war, war_dir] do
  sh "unzip #{warbler.config.war_name}.war -d #{war_dir}"
  sh "mv #{war_dir}/WEB-INF/{.bundle,bundle}"
end

task :explode_gemjar => [:clean, 'war:gemjar', :war, war_dir] do
  sh "unzip #{warbler.config.war_name}.war -d #{war_dir}"
end

desc "deploy to gae"
task :deploy => [:explode] do
  begin
    require '/opt/homebrew/Cellar/app-engine-java-sdk/1.3.2/lib/appengine-tools-api.jar'
    Java::ComGoogleAppengineToolsAdmin::AppCfg.main(['update', war_dir].to_java(:string))
  rescue LoadError
    sh "appcfg.sh update #{war_dir}"
  end
end

task :curl do
  sh "curl http://#{version}.latest.supermarket-api.appspot.com/org.jruby.ruboto.irb/comments"
end

namespace :bundle do
  task :install do
    sh "jruby -S bundle install vendor/gems --disable-shared-gems"
  end
end

def version
  require 'rexml/document'
  doc = REXML::Document.new(IO.read(APPENGINE_WEB_XML))
  REXML::XPath.first(doc, 'appengine-web-app/version').text.to_i
end
