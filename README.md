
# Supermarket

This is a thin JRuby wrapper for the [Android Market API](http://code.google.com/p/android-market-api/) Java project (also mirrored on github: [jberkel/android-market-api](http://github.com/jberkel/android-market-api/)).

It's a new project and only some parts of the protocol have been implemented. I decided to build on top of Java/JRuby because the native Ruby Protocolbuffer implementation ([ruby-protobuf](http://code.google.com/p/ruby-protobuf/)) could not properly handle the [.proto file](http://github.com/jberkel/android-market-api/blob/master/AndroidMarketApi/proto/market.proto) used by the API.

## Synopis
    require 'supermarket'
    session = Supermarket::Session.new

    # search apps for term 'foo' return results as json
    puts session.search("foo").to_json

    # retrieve comments for an app by app id as xml
    puts session.comments("com.example.my.project").to_xml


## Installation

    $ gem install supermarket

You will need to provide your Google market credentials in ~/.supermarket.yml:

    ---
    login: foo@gmail.com
    password: secret

## Command line usage

### Searching

    $ market search ruboto | jsonpretty
    {
      "app": [
        {
          "rating": "4.642857142857143",
          "title": "Ruboto IRB",
          "ratingsCount": 14,
          "creator": "Jan Berkel",
          "appType": "APPLICATION",
          "id": "9089465703133677000",
          "packageName": "org.jruby.ruboto.irb",
          "version": "0.1",
          "versionCode": 1,
          "creatorId": "\"Jan Berkel\"",
          "ExtendedInfo": {
            "category": "Tools",
            "permissionId": [


    ...

### Comments

    $ market comments org.jruby.ruboto.irb | jsonpretty
    {
      "comments": [
        {
          "rating": 5,
          "creationTime": 1269710736815,
          "authorName": "Nate Kidwell",
          "text": "Tremendous application. More examples would be great (as would integrated rubydocs), but awesome all the same.",
          "authorId": "04441815096871118032"
        },

    ...

### Screenshot

    $ market imagedata org.jruby.ruboto.irb --image-out=image.jpg

## Credits

This library would be impossible without the code from the [Android Market API](http://code.google.com/p/android-market-api/) project. Serialization support handled by the [protobuf-java-format](http://code.google.com/p/protobuf-java-format/) library.

## License

Copyright (c) 2010, Jan Berkel <jan.berkel@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
