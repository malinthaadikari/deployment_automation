#this is the init manifest
class myfile {
$agents_location='/home/malintha/adikari4'
$command_path='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'


    file { $agents_location:
        ensure => directory,
        mode => '0777',
        owner => 'root',
        group => 'root',
    }

    file { "/home/malintha/adikari4/wso2as-5.2.1.zip":
        mode => "0777",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/filecopy/wso2as-5.2.1.zip',
    }

exec { "install":
command => 'unzip wso2as-5.2.1.zip',
cwd => '/home/malintha/adikari4/',
 path      => $command_path,
logoutput => true,
timeout => 3600,
require => File['/home/malintha/adikari4/wso2as-5.2.1.zip'],
}


exec { "remove_read_only":
command => 'chmod -R 777 wso2as-5.2.1',
cwd => '/home/malintha/adikari4/',
 path      => $command_path,
logoutput => true,
timeout => 3600,
require => Exec['install'],
}


exec { "strating":
    user   	=> 'root',
    environment => 'JAVA_HOME=/home/malintha/jdk1.6.0',
    path        => $command_path,
    command	=> "/home/malintha/adikari4/wso2as-5.2.1/bin/wso2server.sh",
   logoutput => true,
timeout => 3600,
require => Exec['remove_read_only'],
  }
}

class setupESB {
$agents_location='/home/agent2/adikari11'
$wso2_product='wso2esb-4.8.1.zip'
$command_path='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

    file { $agents_location:
        ensure => directory,
        mode => '0777',
        owner => 'root',
        group => 'root',
    }

    file { "${agents_location}/${wso2_product}":
        mode => "0777",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/filecopy/wso2esb-4.8.1.zip',
    }

    
exec { "remove zip":
command => 'rm -r wso2esb-4.8.1.zip',
cwd => $agents_location,
path      => $command_path,
logoutput => true,
timeout => 3600,
require => Exec['remove_read_only'],
}


exec { "remove_read_only":
command => 'chmod -R 777 wso2esb-4.8.1',
cwd => $agents_location,
 path      => $command_path,
logoutput => true,
timeout => 3600,
require => Exec['install'],
}


exec { "strating":
    user   	=> 'root',
    environment => 'JAVA_HOME=/home/agent2/jdk1.6.0',
    path        => $command_path,
    command	=> "${agents_location}/wso2esb-4.8.1/bin/wso2server.sh",
   logoutput => true,
timeout => 3600,
require => Exec['remove zip'],
  }


exec { "install":
command => 'unzip wso2as-5.2.1.zip',
cwd => '/home/malintha/adikari4/',
 path      => $command_path,
logoutput => true,
timeout => 3600,
require => File['/home/malintha/adikari4/wso2esb-4.8.1.zip'],
}


}
