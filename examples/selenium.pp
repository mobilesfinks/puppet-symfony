#
# sudo puppet apply /etc/puppet/modules/symfony/example/rabbitmq.pp
#

class { 'symfony':
    withMySql           => false,
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false,
    withRabbitMQ        => false
}