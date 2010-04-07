#!/usr/bin/env jruby
require 'rubygems'
require 'java'
require 'yaml'
require 'json'

require File.dirname(__FILE__) + "/jars/AndroidMarketApi.jar"
require File.dirname(__FILE__) + "/jars/protobuf-java-2.2.0.jar"
require File.dirname(__FILE__) + "/formats"


#A thin Ruby wrapper around the Java based Android Market API
#http://code.google.com/p/android-market-api/
module Supermarket
  import 'com.gc.android.market.api.MarketSession'
  import 'com.gc.android.market.api.model.Market'


  class Session
    attr_reader :_session

    def initialize(opts={})
      opts.merge!(self.class.config)
      @_session = MarketSession.new
      if opts['authToken']
        @_session.setAuthToken(opts['authToken'])
      else
        @_session.login(opts['login'], opts['password'])
      end
    end


    def self.config_file
      File.join(ENV['HOME'], '.supermarket.yml')
    end

    def self.config
      @config ||= begin
        if defined? $servlet_context
          { 'login' => $servlet_context.getInitParameter('market_login') ,
            'password' => $servlet_context.getInitParameter('market_password') }
        else
          File.exists?(config_file) ? YAML.load_file(config_file) : {}
        end
      end
    end


    def search(query, extended=true, start=0, count=10)
      request = Market::AppsRequest.newBuilder().
        setQuery(query).
        setStartIndex(start).
        setEntriesCount(count).
        setWithExtendedInfo(extended).build()
      execute(request)
    end


    def comments(app_id, start=0, count=10)
      raise ArgumentError, "need app id" unless app_id

      request = Market::CommentsRequest.newBuilder().
        setAppId(app_id).
        setStartIndex(start).
        setEntriesCount(count).build()

      if resp = execute(request)
        resp
      else
        #raise ArgumentError, "request returned nil"
        nil
      end
    end

    # fetch all available comments
    def all_comments(app_id, c=[])
      comments_resp = comments(app_id, c.size, 10)
      c += comments_resp.comments_list.to_a
      if comments_resp.entriesCount == c.size
        c
      else
        all_comments(app_id, c)
      end
    end

    def image(app_id, usage=Market::GetImageRequest::AppImageUsage::SCREENSHOT, image_id='1')
      request = Market::GetImageRequest.newBuilder().
        setAppId(pkg_to_app_id(app_id)).
        setImageUsage(usage).
        setImageId(image_id).build()

      execute(request)
		end

		def image_data(app_id, usage=Market::GetImageRequest::AppImageUsage::SCREENSHOT, image_id='1')
      if resp = image(app_id, usage, image_id)
		    String.from_java_bytes(resp.getImageData().toByteArray())
	    else
	      []
      end
	  end

    # Resolves a package name to a package id
    def pkg_to_app_id(package)
      return package if package =~ /\A-?\d+\Z/

      if app = search(package).getAppList().to_a.find { |app| app.packageName == package }
        app.getId()
      else
        raise ArgumentError, "could not resolve package #{package}"
      end
    end

    protected
    def execute(request)
      response = nil
      _session.append(request) do |ctxt, resp|
        response = resp
      end
      _session.flush
      response
    end
  end
end
