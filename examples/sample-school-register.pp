#
# sudo puppet apply /etc/puppet/modules/symfony/example/sample-school-register.pp
#

class { 'symfony':
    directory    => '/vagrant/sample/symfony-bdd-app-03-school-register/web',
    username     => 'vagrant',
    withNodejs   => false,
    withAllPhars => false,
}