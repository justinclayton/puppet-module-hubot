## Manages a Hubot using node packages from EPEL
class hubot(
  $enable_epel = false,
  $root_dir = '/opt/hubot',
  $adapter = 'hipchat',
  $user = 'root',
  $brain = 'redis'
) {

  if $::osfamily != 'RedHat' {
    fail("unsupported osfamily \"${::osfamily}\"")
  }

  if $enable_epel {
    include epel
    Class['epel'] -> Package <||>
  }

  case $adapter {
    'hipchat': {
      # do hipchatty things
    }
    'irc': {
      warn("irc not implemented yet, but coming soon")
    }

    default: {
      fail("unsupported hubot adapter \"${adapter}\"")
    }
  }

  case $brain {
    'redis': {
      class { 'redis':
        enable_epel => $enable_epel,
        before      => Service['hubot'],
      }
    }
    default: {
      fail("unsupported hubot brain \"${brain}\"")
    }
  }

  $packagelist = [
    'nodejs',
    'npm',
  ]

  package { $packagelist:
    ensure => installed,
  }

  # init script
  file { '/etc/init.d/hubot':
    ensure  => file,
    mode    => '0755',
    content => template('hubot/hubot.init.erb'),
  }

  if ! defined( File[$root_dir] ) {
    file { $root_dir:
      ensure => directory,
      owner  => $user,
    }
  }

  service { 'hubot':
    ensure => running,
    enable => true,
  }
}