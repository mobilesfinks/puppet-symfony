# = Class: symfony::params
#
class symfony::params {
    $username            = 'vagrant'
    $directory           = '/vagrant/web'
    $withEnvironment     = true
    $withMySql           = true
    $withNodejs          = true
    $withAllPhars        = true
    $withComposerInstall = true
    $withPhpMyAdmin      = true
    $repo                = 'https://github.com/by-examples/symfony-standard.git'
    $branch              = '2.6.4/Full.6'
}
