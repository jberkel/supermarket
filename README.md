
# Supermarket

This is a thin JRuby wrapper for the [Android Market API](http://code.google.com/p/android-market-api/) Java project (also mirrored on github: [jberkel/android-market-api](http://github.com/jberkel/android-market-api/)).

It's a new project and only some parts of the protocol have been implemented. I decided to build on top of Java/JRuby because the native Ruby Protocolbuffer implementation ([ruby-protobuf](http://code.google.com/p/ruby-protobuf/)) could not properly handle the [.proto file](http://github.com/jberkel/android-market-api/blob/master/AndroidMarketApi/proto/market.proto) used by the API.

## Synopis
    require 'supermarket/session'
    session = Supermarket::Session.new

    # search apps for term 'foo'
    puts session.search("foo")

    # retrieve comments for an app by app id
    puts session.comments("com.example.my.project")

## Installation

    $ gem install supermarket

You will need to provide your Google market credentials:

    $ echo -e "---\nlogin: mylogin@gmail.com\npassword: mypass" > ~/.supermarket.yml

## Command line usage

### Searching

    $ market search ruboto
    app {
      id: "9089465703133677000"
      title: "Ruboto IRB"
      appType: APPLICATION
      creator: "Jan Berkel"
      version: "0.1"
      rating: "4.615384615384615"
      ratingsCount: 13
      ExtendedInfo {
        description: "A Ruby console (IRB), running on Android. Run JRuby code directly on your phone, edit & save scripts.\n\nGreat for testing, debugging & prototyping.\n\n(C) Ruboto (JRuby on Android) project."
        downloadsCount: 0

    ...


### Comments

    $ market comments org.jruby.ruboto.irb
    text: "Working well so far, more samples would be nice."
    rating: 4
    authorName: "manveru"
    creationTime: 1268746607464
    authorId: "10620488450454736758"

    ...
