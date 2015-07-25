#
# sudo puppet apply /etc/puppet/modules/symfony/example/rabbitmq.pp
#

class { 'symfony':
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false
}