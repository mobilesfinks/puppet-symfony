#
# sudo puppet apply /etc/puppet/modules/symfony/example/minimal.pp
#

class { 'symfony':
    withEnvironment     => false,
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false
}