require File.join('lib', 'supermarket')

Warbler::Config.new do |config|
  config.dirs = %w(lib)
  config.includes = FileList["appengine-web.xml",  "config.ru"]
  config.webxml.booter = :rack

  config.webxml.jruby.min.runtimes = 1
  config.webxml.jruby.max.runtimes = 1
  config.webxml.jruby.init.serial = true

  market_config = Supermarket::Session.config
  config.webxml['market_login']     = market_config['login']
  config.webxml['market_password']  = market_config['password']
end

