#
# sudo puppet apply /etc/puppet/modules/symfony/example/phpmyadmin.pp
#

class { 'symfony':
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withRabbitMQ        => false,
    withSelenium        => false
}