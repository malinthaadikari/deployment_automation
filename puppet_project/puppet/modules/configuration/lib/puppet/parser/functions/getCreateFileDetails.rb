require 'rexml/document'
include REXML
module Puppet::Parser::Functions
	newfunction(:getCreateFileDetails, :type => :rvalue ) do |args|
		fileDetails= {}
		doc = REXML::Document.new args[0]
		doc.elements.each("node/create/file") {
		|filedata|
			fileName= filedata.elements["filename"].text
			fileLocation= filedata.elements["location"].text
			fileContent= filedata.elements["content"].text
			fileDetails[fileName] = {
     				   'fileLocation' => fileLocation,
       				   'fileContent'  => fileContent,
      }
    }
		return fileDetails
	end
end
