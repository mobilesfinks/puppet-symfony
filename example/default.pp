#
# sudo puppet apply /vagrant/modules/puppet-symfony/example/default.pp
# sudo puppet apply -e 'include symfony'
#

class { 'symfony':
}