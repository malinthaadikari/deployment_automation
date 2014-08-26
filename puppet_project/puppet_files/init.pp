class change_config{

$ipAdd = $::ipaddress
$hostName = $::hostname
$command_path='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
$allConfigurations=getAllConfigurations($ipAdd)
$filelist = collectFiles($allConfigurations['configurations'])
$product_pack= getPackName($allConfigurations['configurations'])
$agentLocation = "/home/ubuntu/deployment"
$masterfilelocation="puppet:///modules/config/${product_pack}"
$javaHome=$allConfigurations['java_home']
$serverOptions = getServerOptions($allConfigurations['configurations'])
$createNodePresence = 'true'
$agentLocations = "/home/ubuntu/deployments"

#create the "deployment" folder to store server
  file { $agentLocation:
        ensure => directory,
        mode => '0777',
        owner => 'root',
       group => 'root',
    }

#Copying the fresh pack
file { "${agentLocation}/${product_pack}.zip":
        mode => "0777",
        owner => 'root',
        group => 'root',
        source => "puppet:///modules/config/${product_pack}.zip",
    }

host { 'set_hostname':
  name         => "${hostName}",
  ip           => "${ipAdd}",
}

#take the zip from the puppet file server location
#unzip it to te agent
exec { "unzip_pack":
command => "unzip ${product_pack}.zip",
cwd => $agentLocation,
user => 'root',
path => $command_path,
unless => 'bash -c "test -d /home/ubuntu/deployment/wso2mb-2.2.0"',
logoutput => true,
require => File["${agentLocation}/${product_pack}.zip"],
}


define create_file($fileName=$name, $fileLocation, $fileContent) {

    file { "${fileLocation}/${fileName}/":
        ensure  => present,
        owner   => 'ubuntu',
        group   => 'ubuntu',
        mode    => '0644',
        content => "${fileContent}",
}
}

define create_folder($fileName=$name, $fileLocation) {

    file { "${fileLocation}/${fileName}/":
        ensure  => directory,
        owner   => 'ubuntu',
        group   => 'ubuntu',
        mode    => '0777',
}
}

define fill_template($fileName=$name, $fileLocation) {
    file { "${fileLocation}/${fileName}/":
        ensure  => present,
        owner   => 'ubuntu',
        group   => 'ubuntu',
        mode    => '0644',
        content => template("config/${fileName}.erb"),
}

}

Host<| title == "set_hostname" |> -> Exec<| title == "unzip_pack" |> -> Change_config::Fill_template<| |> -> Change_config::Create_folder<| |> -> Change_config::Create_file<| |> -> Exec<| title == "strating" |>

$createFolderDetail = getCreateFolderDetail($allConfigurations['configurations'])
create_resources(change_config::create_folder, $createFolderDetail)

$configFileDetails = getConfigFileDetails($allConfigurations['configurations'])
create_resources(change_config::fill_template, $configFileDetails)

$createFileDetails = getCreateFileDetails($allConfigurations['configurations'])
create_resources(change_config::create_file, $createFileDetails)

Change_config::Fill_template<| |> -> Exec<| title == "strating" |>

exec { "strating":
    user        => 'root',
    environment => "JAVA_HOME=/home/ubuntu/tools/jdk1.6.0_45",
    path        => $command_path,
    command     => "sh ${agentLocation}/${product_pack}/bin/wso2server.sh ${serverOptions}",
 }   
}

