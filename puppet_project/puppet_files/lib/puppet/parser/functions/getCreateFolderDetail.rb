require 'rexml/document'
include REXML
module Puppet::Parser::Functions
        newfunction(:getCreateFolderDetail, :type => :rvalue ) do |args|
                folderDetails= {}
                doc = REXML::Document.new args[0]
                doc.elements.each("node/create/folder") {
                |filedata|
                        fileName= filedata.elements["name"].text
                        fileLocation= filedata.elements["location"].text
                        folderDetails[fileName] = {
                                   'fileLocation' => fileLocation,
      }
    }
                return folderDetails
        end
end

