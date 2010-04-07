#!/usr/bin/env jruby

environment = ['.bundle', 'bundle'].map { |f|
  File.expand_path("../../../#{f}/environment.rb", __FILE__)
}.select { |f| File.exists?(f) }

if environment.empty?
  require 'rubygems'
  require 'bundler'
  Bundler.setup
else
  require environment.first
end

require File.join(File.dirname(__FILE__), 'session')
Bundler.require(:default, :web)

module Supermarket
  class Api < Sinatra::Base
    include Rack::RespondTo
    reset!

    not_found do
      content_type :json
      [404, { 'error' => 'not found' }.to_json]
    end

    get("/:id/comments") do
      session  = Session.new
      if comments = session.comments(params[:id])
        respond_to do |wants|
          wants.json {comments.to_json}
          wants.xml  {comments.to_xml}
          wants.html {comments.to_html}
        end
      else
        raise Sinatra::NotFound
      end
    end

    # get("/:id/image") do
    #   content_type :jpeg
    #
    #   session  = Session.new
    #   session.image_data(params[:id])
    # end

    def respond_to
      env['HTTP_ACCEPT'] ||= 'text/html'
      Rack::RespondTo.env = env

      super { |format|
        yield(format).tap do |response|
          type = Rack::RespondTo::Helpers.match(Rack::RespondTo.media_types, format).first
          content_type(type) if type
        end
      }
    end
  end


  class ClientLogin < Sinatra::Base
    reset!
  end
end
