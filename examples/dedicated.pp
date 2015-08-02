#
# sudo puppet apply /etc/puppet/modules/symfony/example/dedicated.pp
#

class { 'symfony':
    appDomain           => 'lorem.ipsum.net',
    withEnvironment     => true,
    withMySql           => true,
    mysqlRootPassword   => 'what-is-it123',
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false,
    withRabbitMQ        => true,
    rabbitMQHost        => 'rab_host',
    rabbitMQUser        => 'rab_user',
    rabbitMQPassword    => 'rab_password',
    withSelenium        => true
}