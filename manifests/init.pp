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

    include stdlib
    include mysql::server
    include ::apache::mod::rewrite
    include php5
    include environment
    include nodejs

    class { 'ubuntu':
        stage => setup;
    }

    exec { 'install less node module':
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => 'npm install -g less &> /dev/null',
        require => Class['nodejs'],
    }

    class { 'php_phars':
        all   => true,
    }

#    class { 'apache::default_mods':
#        require => Class['apache']
#    }

    class { 'apache':
        mpm_module    => prefork,
        user          => $username,
        group         => $username,
        default_vhost => false,
        default_mods        => false,
        default_confd_files => false,
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
