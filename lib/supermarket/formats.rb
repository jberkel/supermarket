require File.dirname(__FILE__) + "/jars/protobuf-format-java-1.2-SNAPSHOT.jar"


#Serialize protobuf to different formats using
#http://code.google.com/p/protobuf-java-format/
module Supermarket
  module Formats
    import 'com.google.protobuf.JsonFormat'
    import 'com.google.protobuf.XmlFormat'
    import 'com.google.protobuf.HtmlFormat'

    def to_json
      JsonFormat.printToString(self)
    end

    def to_xml
      XmlFormat.printToString(self)
    end

    def to_html
      HtmlFormat.printToString(self)
    end
  end
end