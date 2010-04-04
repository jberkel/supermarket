#!/usr/bin/env ruby
begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../../../.bundle/environment', __FILE__)
rescue LoadError
  # Fall back on doing an unlocked resolve at runtime.
  begin
    require "rubygems"
    require "bundler"
    Bundler.setup
  end
end

Bundler.require(:web, :development)
require File.join(File.dirname(__FILE__), 'session')

Sinatra::Application.register Sinatra::RespondTo
Sinatra::Application.register Sinatra::Reloader

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