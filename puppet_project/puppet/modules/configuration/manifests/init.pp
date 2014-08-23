class change_config{

$ipAdd = $::ipaddress
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

define create_file($fileName=$name, $fileLocation, $fileContent) {

    file { "${fileLocation}/${fileName}/":
        ensure  => present,
        owner   => 'ubuntu',
        group   => 'ubuntu',
        mode    => '0644',
        content => "${fileContent}",
        require => Exec["unzip_pack"],

}
}

define create_folder($fileName=$name, $fileLocation) {

    file { "${fileLocation}/${fileName}/":
        ensure  => directory,
        owner   => 'ubuntu',
        group   => 'ubuntu',
        mode    => '0777',
        require => Exec["unzip_pack"],

}
}

define fill_template($fileName=$name, $fileLocation) {
    file { "${fileLocation}/${fileName}/":
        ensure  => present,
        owner   => 'ubuntu',
        group   => 'ubuntu',
        mode    => '0644',
        content => template("config/${fileName}.erb"),
        require => Exec["unzip_pack"],

}

}

Change_config::Fill_template<| |> -> Change_config::Create_folder<| |> -> Change_config::Create_file<| |>

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
    logoutput => true,
    timeout => 3600,
 }

}

