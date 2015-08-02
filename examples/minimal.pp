#
# sudo puppet apply /etc/puppet/modules/symfony/example/minimal.pp
#

class { 'symfony':
    withEnvironment     => false,
    withMySql           => false,
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false,
    withRabbitMQ        => false,
    withSelenium        => false
}