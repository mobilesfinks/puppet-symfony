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
    $appDomain           = undef,
    $username            = undef,
    $directory           = undef,
    $withEnvironment     = undef,
    $withMySql           = undef,
    $mysqlRootPassword   = undef,
    $withNodejs          = undef,
    $withAllPhars        = undef,
    $withComposerInstall = undef,
    $withPhpMyAdmin      = undef,
    $withRabbitMQ        = undef,
    $repo                = undef,
    $branch              = undef
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

    $param_appDomain = $appDomain ? {
        undef   => $::symfony::params::appDomain,
        default => $appDomain
    }

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

    $param_mysqlRootPassword = $mysqlRootPassword ? {
        undef   => $::symfony::params::mysqlRootPassword,
        default => $mysqlRootPassword
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

    $param_withPhpMyAdmin = $withPhpMyAdmin ? {
        undef   => $::symfony::params::withPhpMyAdmin,
        default => $withPhpMyAdmin
    }

    $param_withRabbitMQ = $withRabbitMQ ? {
        undef   => $::symfony::params::withRabbitMQ,
        default => $withRabbitMQ
    }

    $param_repo = $repo ? {
        undef   => $::symfony::params::repo,
        default => $repo
    }

    $param_branch = $branch ? {
        undef   => $::symfony::params::branch,
        default => $branch
    }


    #
    # The code
    #
    include stdlib
    include apt

    class { 'ubuntu':
        stage => setup;
    }

    include php5

    if $param_withEnvironment {
        include environment
    }

    if $param_withMySql {

        $override_options = {
          'mysqld' => {
            'bind-address' => '0.0.0.0',
          }
        }

        class { '::mysql::server':
          root_password    => $param_mysqlRootPassword,
          override_options => $override_options
        }

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
            phars => ['composer', 'phpunit', 'box', 'php-cs-fixer'],
        }
    } else {
        class { 'php_phars':
            phars => ['composer'],
        }
    }

    if $param_withComposerInstall {
        class { 'composer_install':
            repo    => $param_repo,
            branch  => $param_branch,
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

    apache::vhost { $param_appDomain:
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

    if $param_withPhpMyAdmin {
        include phpmyadmin
        include phpmyadmin::vhost
    }

    if $param_withRabbitMQ {

        class { '::rabbitmq':
          manage_repos      => true,
          version           => '3.5.3',
          service_manage    => true,
          port              => '5672',
          delete_guest_user => true,
        }

        rabbitmq_vhost { 'rabbit_mq_host':
          ensure => present,
        }

        rabbitmq_user { 'RabbitMQUser':
          admin    => true,
          password => 'passR-A-B-B-I-T123'
        }

        rabbitmq_user_permissions { 'RabbitMQUser@rabbit_mq_host':
          configure_permission => '.*',
          read_permission      => '.*',
          write_permission     => '.*',
        }

    }

}
