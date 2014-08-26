require 'rexml/document'
include REXML
module Puppet::Parser::Functions
    newfunction(:getConfigFileDetails, :type => :rvalue ) do |args|
        result = {}
        doc = REXML::Document.new args[0]
        doc.elements.each("node/congfigurations/config") {
         |config|
                fileName= config.elements["@fileName"].value
                fileLocation= config.elements["@location"].value
                 result[fileName] = {
                        "fileLocation" => fileLocation,
                }
         }
return result
end
end
