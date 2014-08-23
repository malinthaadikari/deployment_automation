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
}
