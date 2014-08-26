require 'rexml/document'
include REXML
module Puppet::Parser::Functions
    newfunction(:getPackName, :type => :rvalue ) do |args|
        doc = REXML::Document.new args[0]
        productShortName= doc.elements["node/product/@name"].value
        version= doc.elements["node/product/@version"].value
        packName= "wso2"+productShortName+"-"+version
        return packName

    end
end
