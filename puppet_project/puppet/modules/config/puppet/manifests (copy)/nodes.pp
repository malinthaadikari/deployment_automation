node 'debian' {

}

node 'base' {

  #essential variables
  $package_repo         = 'PACKAGE_REPO'
  $local_package_dir    = '/mnt/packs'
  $mb_ip                = 'MB_IP'
  $mb_port              = 'MB_PORT'
  $cep_ip               = 'CEP_IP'
  $cep_port             = 'CEP_PORT'
  $truststore_password  = 'wso2carbon'
  $java_distribution	= 'jdk-7-linux-x64.tar.gz'
  $java_name		= 'jdk1.7.0'
  $member_type_ip       = 'private'

  #following variables required only if you want to install stratos using puppet.
  #not supported in alpha version
  # Service subdomains
  #$domain               = 'stratos.com'
  #$as_subdomain         = 'autoscaler'
  #$management_subdomain = 'management'

  #$admin_username       = 'admin'
  #$admin_password       = 'admin123'

  #$puppet_ip            = '10.4.128.7'
  


  #$cc_ip                = '10.4.128.9'
  #$cc_port              = '9443'

  #$sc_ip                = '10.4.128.13'
  #$sc_port              = '9443'

  #$as_ip                = '10.4.128.8'
  #$as_port              = '9443'

  #$git_hostname        = 'git.stratos.com'
  #$git_ip              = '10.4.128.13'

  $mysql_server         = 'DB_HOST'
  $mysql_port           = 'DB_PORT'
  $max_connections      = '100000'
  $max_active           = '150'
  $max_wait             = '360000'

  $bam_ip              = 'BAM_IP'
  $bam_port            = 'BAM_PORT'
  
  #$internal_repo_user     = 'admin'
  #$internal_repo_password = 'admin'

}

node /debian/ inherits base {
  $docroot = "/mnt/wso2as-5.2.1"
  require java	
  class {'agent':}
  class {'appserver':

        version            => '5.2.1',
        sub_cluster_domain => 'test',
	members            => false,
	offset		   => 0,
        tribes_port        => 4100,
        config_db          => 'AS_CONFIG_DB',
	config_target_path => 'AS_CONFIG_PATH',
        maintenance_mode   => 'zero',
        depsync            => false,
        clustering         => false,
	cloud		   => true,
        owner              => 'root',
        group              => 'root',
        target             => '/mnt/'

  }

}

