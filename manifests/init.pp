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
    $repo                = undef,
    $branch              = undef,
    $withPhpMyAdmin      = undef,
    $withRabbitMQ        = undef,
    $rabbitMQHost        = undef,
    $rabbitMQUser        = undef,
    $rabbitMQPassword    = undef,
    $withSelenium        = undef,
    $withRedis           = undef,
    $withDEVSettings     = undef
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

    $param_rabbitMQHost = $rabbitMQHost ? {
        undef   => $::symfony::params::rabbitMQHost,
        default => $rabbitMQHost
    }

    $param_rabbitMQUser = $rabbitMQUser ? {
        undef   => $::symfony::params::rabbitMQUser,
        default => $rabbitMQUser
    }

    $param_rabbitMQPassword = $rabbitMQPassword ? {
        undef   => $::symfony::params::rabbitMQPassword,
        default => $rabbitMQPassword
    }

    $param_repo = $repo ? {
        undef   => $::symfony::params::repo,
        default => $repo
    }

    $param_branch = $branch ? {
        undef   => $::symfony::params::branch,
        default => $branch
    }

    $param_withSelenium = $withSelenium ? {
        undef   => $::symfony::params::withSelenium,
        default => $withSelenium
    }

    $param_withRedis = $withRedis ? {
        undef   => $::symfony::params::withRedis,
        default => $withRedis
    }

    $param_withDEVSettings = $withDEVSettings ? {
        undef   => $::symfony::params::withDEVSettings,
        default => $withDEVSettings
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
        if $param_withDEVSettings {
            include environment
        } else {
            class { 'environment':
                modifyProfileFiles => false
            }
        }

    }

    if $param_withMySql {

        if $param_withDEVSettings {

            $override_options = {
              'mysqld' => {
                'bind-address' => '0.0.0.0',
              }
            }

        } else {

            $override_options = { }

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
    openssl::certificate::x509 { $param_appDomain:
        country      => 'PL',
        organization => 'Example organization',
        commonname   => $param_appDomain,
    }

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

    if $param_withDEVSettings {

        host { $param_appDomain:
            ip => '127.0.0.1'
        }

        apache::vhost { "http ${param_appDomain}":
            servername    => $param_appDomain,
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

        apache::vhost { "https ${param_appDomain}":
            servername    => $param_appDomain,
            port          => '443',
            ssl           => true,
            ssl_cert      => "/etc/ssl/certs/${param_appDomain}.crt",
            ssl_key       => "/etc/ssl/certs/${param_appDomain}.key",
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

    if $param_withPhpMyAdmin {
        include phpmyadmin
        if $param_withDEVSettings {
            class {'phpmyadmin::vhost':
                require => Class['environment']
            }
        }
    }

    if $param_withRabbitMQ {

        class { '::rabbitmq':
            manage_repos      => true,
            version           => '3.5.3',
            service_manage    => true,
            port              => '5672',
            delete_guest_user => true,
        }

        if $param_withDEVSettings {
            rabbitmq_vhost { $param_rabbitMQHost:
                ensure => present,
            }

            rabbitmq_user { $param_rabbitMQUser:
                admin    => true,
                password => $param_rabbitMQPassword
            }

            $perm = "${$param_rabbitMQUser}@${$param_rabbitMQHost}"
            rabbitmq_user_permissions { $perm:
                configure_permission => '.*',
                read_permission      => '.*',
                write_permission     => '.*',
            }
        }
    }

    if $param_withSelenium {
        include selenium
    }

    if $param_withRedis {
        include redis
    }

}
