#
# sudo puppet apply /vagrant/modules/puppet-symfony/example/minimal.pp
#

class { 'symfony':
    withEnvironment => false,
    withMySql       => false,
    withNodejs      => false,
    withAllPhars    => false,
}