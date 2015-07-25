#
# sudo puppet apply /etc/puppet/modules/symfony/example/dedicated.pp
#

class { 'symfony':
    appDomain           => 'lorm.ipsum.net',
    withEnvironment     => false,
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false
}