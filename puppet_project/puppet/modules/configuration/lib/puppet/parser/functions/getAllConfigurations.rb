module Puppet::Parser::Functions
    newfunction(:getAllConfigurations, :type => :rvalue ) do |args|
        configs = Hash.new
        line_num=0
        text=File.open('/tmp/'+ args[0]).read
        text.gsub!(/\r\n?/, "\n")
        text.each_line do |line|
                key=line.split(',')[0]
                value=line.split(',')[1]
                configs.store(key, value)
        end
       return configs
    end
end

