require 'rexml/document'
include REXML
module Puppet::Parser::Functions
    newfunction(:adikari, :type => :rvalue ) do |args|
	doc = REXML::Document.new args[0]
            return doc.elements["configurations/nodes/node[@type='loadBalancer']/domainname"].text
       
    end
end
