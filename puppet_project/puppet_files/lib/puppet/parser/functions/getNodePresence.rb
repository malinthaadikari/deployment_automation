require 'rexml/document'
include REXML
module Puppet::Parser::Functions
    newfunction(:getNodePresence, :type => :rvalue ) do |args|
        doc = REXML::Document.new args[0]
        nodecount = REXML::XPath.first(doc, "count(node/"+ args[1]+")")
	presence = false
	if ( nodecount >= 1)
        	presence = true
	end
	return presence
    end
end
