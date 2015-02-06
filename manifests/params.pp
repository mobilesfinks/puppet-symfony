# = Class: symfony::params
#
class symfony::params {

    $username        = 'vagrant'

#
# Default values are autoguessed with whoami and pwd
#    $directory       = '/vagrant/web'
#
    $withEnvironment = true
    $withMySql       = true
    $withNodejs      = true
    $withAllPhars    = true
}
