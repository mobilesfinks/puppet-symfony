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
    $username            = undef,
    $directory           = undef,
    $withEnvironment     = undef,
    $withMySql           = undef,
    $withNodejs          = undef,
    $withAllPhars        = undef,
    $withComposerInstall = undef
) {

    # validate_platform() function comes from
    # puppet module gajdaw/diverse_functions
    #
    #     https://forge.puppetlabs.com/gajdaw/diverse_functions
    #
    if !validate_platform($module_name) {
        fail("Platform not supported in module '${module_name}'.")
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

    $param_withComposerInstall = $withComposerInstall ? {
        undef   => $::symfony::params::withComposerInstall,
        default => $withComposerInstall
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

    if $param_withComposerInstall {
        class { 'composer_install':
            require => Class['environment', 'php5', 'php_phars']
        }
    }

    #
    # Apache module
    #
    #
    include ::apache::mod::rewrite

    class { 'apache':
        mpm_module    => prefork,
        user          => $param_username,
        group         => $param_username,
        default_vhost => false,
        require       => Class['php5'];
    }

    class { '::apache::mod::php':
        path => "${::apache::params::lib_path}/libphp5.so",
    }

    apache::vhost { 'app.lh':
        port          => '80',
        docroot       => $param_directory,
        docroot_owner => $param_username,
        docroot_group => $param_username,
        notify        => Service['apache2'],
        directories   => [
            {
                path           => $param_directory,
                allow_override => ['All'],
            },
        ],
    }

}
