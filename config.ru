require './lib/supermarket/api'
#Sinatra::Application.set :environment, :production
use Rack::AbstractFormat
run Supermarket::Api
