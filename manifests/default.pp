file {
	"default":
	mode => 644,
	owner => root,
	group => root,
	path => "/etc/apache2/sites-available/default",
	source => "/vagrant/default",
}	

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
 
class system-update{
 
  exec { 'apt-get update':
		command => 'apt-get update',
	}
				 
}
				 
class php5{
	package { "php5":
		ensure => present,
		require => Exec['apt-get update'],
	}
}
																 
class mysql {
	package { ['mysql-common', 'mysql-client', 'mysql-server']:
		ensure => present
	}
																							 
	package { "php5-mysql" :
		ensure => installed,
		require => Package['php5'],
	}
																													 
	service { 'mysql':
		enable => true,
		ensure => running,
		require => Package['mysql-server']
	}
																																										 
	exec { 'set-root-password':
		subscribe => [Package['mysql-common'], Package['mysql-client'], Package['mysql-server']],
		refreshonly => true,
		unless => "mysqladmin -uroot -proot",
		command => "mysqladmin -uroot password root",
		#require => Package['mtop'] # mtop needs an empty root password
	}
}
																																																									 
																																																																									   
																																																																									 
include system-update
include php5
include mysql
