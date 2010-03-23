
# Supermarket

This is a thin JRuby wrapper for the [Android Market API](http://code.google.com/p/android-market-api/) Java project (also mirrored on github: [jberkel/android-market-api](http://github.com/jberkel/android-market-api/)).

It's a new project and only some parts of the protocol have been implemented. I decided to build on top of Java/JRuby because the native Ruby Protocolbuffer implementation ([ruby-protobuf](http://code.google.com/p/ruby-protobuf/)) could not properly handle the [.proto file](http://github.com/jberkel/android-market-api/blob/master/AndroidMarketApi/proto/market.proto) used by the API.

## Synopis

    # set up google market credentials
    $ echo -e "---\nlogin: mylogin@gmail.com\npassword: mypass" > ~/.supermarket.yml

    require 'supermarket/session'
    session = Supermarket::Session.new

    # search apps for term 'foo'
    puts session.search("foo")

    # retrieve comments for an app by app id
    puts session.comments("com.example.my.project")

