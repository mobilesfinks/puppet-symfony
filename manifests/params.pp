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
    $repo                = 'https://github.com/by-examples/symfony-standard.git'
    $branch              = '2.7.3/Full.5'
    $withPhpMyAdmin      = true
    $withRabbitMQ        = true
    $rabbitMQHost        = 'rabbit_mq_host'
    $rabbitMQUser        = 'RabbitMQUser'
    $rabbitMQPassword    = 'passR-A-B-B-I-T123'
    $withSelenium        = true
    $withRedis           = true
    $withDEVSettings     = true
}
