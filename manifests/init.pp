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

    if !($::operatingsystem == 'Ubuntu' and $::lsbdistrelease == '14.04') {
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

    include ::apache::mod::rewrite

    class { 'apache':
        mpm_module    => prefork,
        user          => $username,
        group         => $username,
        default_vhost => false,
        require       => Class['php5'];
    }

    class {'::apache::mod::php':
        path => "${::apache::params::lib_path}/libphp5.so",
    }

    apache::vhost { 'app.lh':
        port          => '80',
        docroot       => $directory,
        docroot_owner => $username,
        docroot_group => $username,
        notify        => Service['apache2'],
        directories   => [
            { path => $directory,
                allow_override => ['All'],
            },
        ],
    }

}
