#
# sudo puppet apply /etc/puppet/modules/symfony/example/dedicated.pp
#

class { 'symfony':
    appDomain           => 'lorem.ipsum.net',
    withEnvironment     => false,
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false,
    withRabbitMQ        => false
}