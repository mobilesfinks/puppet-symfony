# == Class: symfony
#
# Class to install software required by Symfony Standard.
#
# === Authors
#
# Włodzimierz Gajda <gajdaw@gajdaw.pl>
#
# === Copyright
#
# Copyright 2015 Włodzimierz Gajda
#

class symfony (
  $username  = 'vagrant',
  $directory = '/vagrant/web',
) {

    if !(
        ($::operatingsystem == 'Ubuntu' and $::lsbdistrelease == '14.04') or
        ($::operatingsystem == 'Ubuntu' and $::lsbdistrelease == '12.04')
    ) {
        fail('Platform not supported.')
    }

    include stdlib

    class { 'ubuntu':
        stage => setup;
    }

    include mysql::server
    include environment
    include php5
    include nodejs

    exec { 'install less node module':
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => 'npm install -g less &> /dev/null',
        require => Class['nodejs'],
    }

    class { 'php_phars':
        all   => true,
    }

    exec { 'php5:mod-rewrite':
        path    => '/usr/bin:/usr/sbin:/bin',
        command => 'a2enmod rewrite',
        require => Package['php5'],
        notify  => Service['apache2'],
    }

    file_line { 'apache_user':
        path    => '/etc/apache2/envvars',
        line    => "export APACHE_RUN_USER=${username}",
        match   => 'export APACHE_RUN_USER=www-data',
        require => Package['php5'],
        notify  => Service['apache2'],
    }

    file_line { 'apache_group':
        path    => '/etc/apache2/envvars',
        line    => "export APACHE_RUN_GROUP=${username}",
        match   => 'export APACHE_RUN_GROUP=www-data',
        require => Package['php5'],
        notify  => Service['apache2'],
    }

    file_line { 'apache2-enable-htaccess-files':
        path     => '/etc/apache2/apache2.conf',
        match    => '^\s*AllowOverride None',
        multiple => true,
        line     => "\tAllowOverride All",
        require  => Package['php5'],
        notify  => Service['apache2'],
    }

    file { '/var/www/html':
        path    => '/var/www/html',
        ensure  => link,
        force   => true,
        target  => '/vagrant/web',
        require => [Package['php5']]
    }

}
