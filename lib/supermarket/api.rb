#!/usr/bin/env jruby

require File.expand_path('../../../.bundle/environment', __FILE__)
require File.join(File.dirname(__FILE__), 'session')
Bundler.require(:default, :web)

module Supermarket
  class Api < Sinatra::Application
    include Rack::RespondTo

    get("/:id/comments") do
      session  = Session.new
      comments = session.comments(params[:id])

      comments.to_json

      respond_to do |wants|
        wants.json {comments.to_json}
        wants.xml  {comments.to_xml}
        wants.html {comments.to_html}
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
end
