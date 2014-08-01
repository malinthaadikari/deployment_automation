#this is init.pp
class change_config{
$command_path='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
$allConfigurations=getAllConfigurations()
$filelist = collectFiles($allConfigurations['configurations'])
$product_pack= getPackName($allConfigurations['configurations'])
$agentLocation = "/home/ubuntu/deployment"
$masterfilelocation="puppet:///modules/config/${product_pack}"
$javaHome=$allConfigurations['java_home']

  file { $agentLocation:
        ensure => directory,
        mode => '0777',
        owner => 'root',
        group => 'root',
    }

file { "${agentLocation}/${product_pack}.zip":
        mode => "0777",
        owner => 'root',
        group => 'root',
        source => "puppet:///modules/config/${product_pack}.zip",
    }


#take the zip from the puppet file server location
#unzip it to te agent

exec { "unzip_pack":
command => "unzip ${product_pack}.zip",
cwd => $agentLocation,
path      => $command_path,
logoutput => true,
timeout => 3600,
require => File["${agentLocation}/${product_pack}.zip"],
}

#replace config files

define fill_templates() {
    $fileName = $name["filename"]                                                       
    $fileLocation = $name['filelocation']   
    file { "${fileLocation}/${fileName}/":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        content => template("config/${fileName}.erb"),
	require => Exec["unzip_pack"],
}

}
 
$configFileDetails = getConfigFileDetails($allConfigurations['configurations'])  
fill_templates { $configFileDetails: }


#start the server

exec { "strating":
    user   	=> 'root',
    environment => "JAVA_HOME=/home/ubuntu/tools/jdk1.6.0_45",
    path        => $command_path,
    command	=> "${agentLocation}/${product_pack}/bin/wso2server.sh start",
    logoutput => true,
    timeout => 3600,
#require => Fill_templates[$configFileDetails],
 }

#notify { "Curent product pack is ${javaHome}" :}

}
