require 'rexml/document'
include REXML
module Puppet::Parser::Functions
    newfunction(:getConfigFileDetails, :type => :rvalue ) do |args|
	fileDetails= []
	doc = REXML::Document.new args[0]
	doc.elements.each("node/congfigurations/config") {
	 |config| 
		fileName= config.elements["@fileName"].value
		fileLocation= config.elements["@location"].value
		fileDetails << {'filename' => fileName, 'filelocation'=> fileLocation}
	}
        return fileDetails 
    end
end
