require 'rexml/document'
include REXML
module Puppet::Parser::Functions
    newfunction(:getServerOptions, :type => :rvalue ) do |args|
        doc = REXML::Document.new args[0]
        serverOptions = doc.elements["node/serverOptions"].text
        return serverOptions
    end
end
