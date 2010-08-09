require 'rake/clean'
require 'date'
CLEAN.include('pkg', 'tmp')

#############################################################################
#
# Gem related stuff
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def platform
  eval(IO.read(gemspec_file)).platform.to_s
end

def gem_file
  "#{name}-#{version}-#{platform}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

task :default => :test

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master --tags"
  sh "gem push pkg/#{gem_file}"
end

desc "Builds the gem"
task :build => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

task :gemspec => :validate do
  # read spec file and split out manifest section
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")

  # replace name version and date
  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)
  #comment this out if your rubyforge_project has a different name
  replace_header(head, :rubyforge_project)

  # determine file list from git ls-files
  files = `git ls-files`.
    split("\n").
    sort.
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg)/ }.
    map { |file| "    #{file}" }.
    join("\n")

  # piece file back together and write
  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head, manifest, tail].join("  # = MANIFEST =\n")
  File.open(gemspec_file, 'w') { |io| io.write(spec) }
  puts "Updated #{gemspec_file}"
end

task :validate do
  libfiles = Dir['lib/*'] - ["lib/#{name}.rb", "lib/#{name}"]
  unless libfiles.empty?
    puts "Directory `lib` should only contain a `#{name}.rb` file and `#{name}` dir."
    exit!
  end
  unless Dir['VERSION*'].empty?
    puts "A `VERSION` file at root level violates Gem best practices."
    exit!
  end
end

#############################################################################
#
# Appengine
#
#############################################################################

begin
  require 'warber'

  APPENGINE_WEB_XML = "appengine-web.xml"
  war_dir = "tmp/war"
  directory war_dir

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

  namespace :bundle do
    task :install do
      sh "jruby -S bundle install vendor/gems --disable-shared-gems"
    end
  end

  def app_version
    require 'rexml/document'
    doc = REXML::Document.new(IO.read(APPENGINE_WEB_XML))
    REXML::XPath.first(doc, 'appengine-web-app/version').text.to_i
  end
rescue LoadError => e
end
