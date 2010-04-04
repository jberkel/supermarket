#!/usr/bin/env ruby
if ENV['DEV']
  require File.expand_path('../../../.bundle/environment', __FILE__)
  Bundler.require(:web, :development)
  Sinatra::Application.register Sinatra::Reloader
else
  require 'rubygems'
  require 'sinatra'
  require 'sinatra/respond_to'
end

require File.join(File.dirname(__FILE__), 'session')
Sinatra::Application.register Sinatra::RespondTo

module Supermarket
  class Api
    Sinatra::Application.get("/:id/comments") do
      session  = Session.new
      comments = session.comments(params[:id])

      respond_to do |wants|
        wants.json {comments.to_json}
        wants.xml  {comments.to_xml}
        wants.html {comments.to_html}
      end
    end
 end
end