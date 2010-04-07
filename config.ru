require File.expand_path('lib/supermarket/api.rb')
require 'rack/reloader'
#Sinatra::Application.set :environment, :production
use Rack::AbstractFormat
use Rack::Reloader, 0 if Sinatra::Application.development?

map '/login' do
  run Supermarket::ClientLogin
end

map '/api' do
  run Supermarket::Api
end
