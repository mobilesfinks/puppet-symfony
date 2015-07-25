# = Class: symfony::params
#
class symfony::params {
    $appDomain           = 'app.lh'
    $username            = 'vagrant'
    $directory           = '/vagrant/web'
    $withEnvironment     = true
    $withMySql           = true
    $mysqlRootPassword   = 's-e-c-r-e-t-PA55w0rd'
    $withNodejs          = true
    $withAllPhars        = true
    $withComposerInstall = true
    $withPhpMyAdmin      = true
    $withRabbitMQ        = true
    $repo                = 'https://github.com/by-examples/symfony-standard.git'
    $branch              = '2.6.4/Full.6'
}
