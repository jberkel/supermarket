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
    @@order_type = {
      :none     => Market::AppsRequest::OrderType.value_of(0),
      :popular  => Market::AppsRequest::OrderType.value_of(1),
      :newest   => Market::AppsRequest::OrderType.value_of(2),
      :featured => Market::AppsRequest::OrderType.value_of(3)
    }
    def order_type(type_sym);@@order_type[type_sym];end

    def initialize(opts={})
      opts.merge!(self.class.config)
      @_session = MarketSession.new
      @_session.getContext().setAndroidId("304c75341a12ef3c");
      if opts['authToken']
        @_session.setAuthSubToken(opts['authToken'])
      else
        raise "Need login and password" unless opts['login'] && opts['password']
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

    def get_app(app_id)
      request_builder = Market::AppsRequest.newBuilder()
      request_builder.set_app_id(app_id).set_with_extended_info(true) 
      execute(request_builder.build())
    end


    def search(query=nil, categid=nil,extended=true, start=0, count=10, order=:popular)
      request_builder = Market::AppsRequest.newBuilder()

      if query.nil? and !categid.nil?
        request_builder.setCategoryId(categid)
      elsif !query.nil? and categid.nil?
        request_builder.setQuery(query)
      elsif !query.nil? and !categid.nil?
        request_builder.setQuery(query)
        request_builder.setCategoryId(categid)
      else
        raise "query or category_id must not be nil."
      end
      
      request_builder.
        setStartIndex(start).
        setEntriesCount(count).
        setWithExtendedInfo(extended).
        setOrderType(order_type(order))


      execute(request_builder.build())
    end

    def categories()
      request = Market::CategoriesRequest.newBuilder().build()
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
    def all_comments(app_id, c=[], &progress)
      progress ||= proc { |s| sleep 1.5 } # avoid those 503/502

      comments_resp = comments(app_id, c.size, 10)
      c += comments_resp.comments_list.to_a
      if comments_resp.entriesCount == c.size
        c
      else
        progress.call(c.size)
        all_comments(app_id, c, &progress)
      end
    end

    def image(app_id, usage=:screenshot, image_id='1')
      case usage
      when :screenshot
        usage_const = Market::GetImageRequest::AppImageUsage::SCREENSHOT
      when :icon
        usage_const = Market::GetImageRequest::AppImageUsage::ICON
      end

      request = Market::GetImageRequest.newBuilder().
        setAppId(pkg_to_app_id(app_id)).
        setImageUsage(usage_const).
        setImageId(image_id).build()

      execute(request)
		end

		def image_data(app_id, usage=:screenshot, image_id='1')
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
