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
    $username        = undef,
    $directory       = undef,
    $withEnvironment = undef,
    $withMySql       = undef,
    $withNodejs      = undef,
    $withAllPhars    = undef
) {

    #
    # Handle platforms
    #
    if !(
        ($::operatingsystem == 'Ubuntu' and $::lsbdistrelease == '14.04') or
        ($::operatingsystem == 'Ubuntu' and $::lsbdistrelease == '12.04')
    ) {
        fail('Platform not supported.')
    }


    #
    # Handle parameters
    #
    include symfony::params

    $param_username = $username ? {
        undef   => $::symfony::params::username,
        default => $username
    }

    $param_directory = $directory ? {
        undef   => $::symfony::params::directory,
        default => $directory
    }

    $param_withEnvironment = $withEnvironment ? {
        undef   => $::symfony::params::withEnvironment,
        default => $withEnvironment
    }

    $param_withMySql = $withMySql ? {
        undef   => $::symfony::params::withMySql,
        default => $withMySql
    }

    $param_withNodejs = $withNodejs ? {
        undef   => $::symfony::params::withNodejs,
        default => $withNodejs
    }

    $param_withAllPhars = $withAllPhars ? {
        undef   => $::symfony::params::withAllPhars,
        default => $withAllPhars
    }


    #
    # The code
    #
    include stdlib

    class { 'ubuntu':
        stage => setup;
    }

    include php5

    if $param_withEnvironment {
        include environment
    }

    if $param_withMySql {
        include mysql::server
    }

    if $param_withNodejs {

        include nodejs

        exec { 'install less node module':
            path    => '/usr/bin:/bin:/usr/sbin:/sbin',
            command => 'npm install -g less &> /dev/null',
            require => Class['nodejs'],
        }

    }

    if $param_withAllPhars {
        class { 'php_phars':
            all   => true,
        }
    } else {
        class { 'php_phars':
            phars => ['composer'],
        }
    }

    service { 'apache2':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['php5'],
    }

    exec { 'php5:mod-rewrite':
        path    => '/usr/bin:/usr/sbin:/bin',
        command => 'a2enmod rewrite',
        require => Package['php5'],
        notify  => Service['apache2'],
    }

    file_line { 'apache_user':
        path    => '/etc/apache2/envvars',
        line    => "export APACHE_RUN_USER=${param_username}",
        match   => 'export APACHE_RUN_USER=www-data',
        require => Package['php5'],
        notify  => Service['apache2'],
    }

    file_line { 'apache_group':
        path    => '/etc/apache2/envvars',
        line    => "export APACHE_RUN_GROUP=${param_username}",
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
        target  => $param_directory,
        require => [Package['php5']]
    }

}
