# Apply the templates
define config::push_templates ($directory, $target) {
  file { '/home/malintha/adikari4':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0755',
    content => template("carbon.xml.erb"),
  }
}
