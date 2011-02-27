Gem::Specification.new do |s|
  s.name = 'supermarket'
  s.version = '0.0.5'
  s.platform = 'universal-java'

  s.rubyforge_project = 'supermarket'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Berkel"]
  s.date = '2011-02-27'
  s.default_executable = %q{market}
  s.description = %q{An unoffical/reverse engineered API for Android market.}
  s.email = %q{jan.berkel@gmail.com}
  s.executables = ["market"]
  s.extra_rdoc_files = [
    "README.md"
  ]

  # = MANIFEST =
  s.files = %w[
    CHANGES
    Gemfile
    Gemfile.lock
    README.md
    Rakefile
    appengine-web.xml
    bin/market
    config.ru
    config/warble.rb
    lib/supermarket.rb
    lib/supermarket/api.rb
    lib/supermarket/formats.rb
    lib/supermarket/jars/AndroidMarketApi.jar
    lib/supermarket/jars/protobuf-format-java-1.2-SNAPSHOT.jar
    lib/supermarket/jars/protobuf-java-2.2.0.jar
    lib/supermarket/session.rb
    supermarket.gemspec
  ]
  # = MANIFEST =
  s.homepage = %q{http://github.com/jberkel/supermarket}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{JRuby bindings for android-market-api}

   s.add_dependency(%q<json-jruby>, [">= 0"])
end

