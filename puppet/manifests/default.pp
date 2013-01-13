$canvas_databases = ['canvas_development', 'canvas_queue_development', 'canvas_test']

# Make sure apt-get -y update runs before anything else.
stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { '/usr/bin/apt-get -y update':
    user => 'root'
  }
}
class { 'apt_get_update':
  stage => preinstall
}

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    require   => Class['postgresql::server']
  }

  pg_user { 'canvas':
    ensure   => present,
    password => 'canvas',
    require  => Class['postgresql::server']
  }

  pg_database { $canvas_databases:
    ensure   => present,
    owner    => 'canvas',
    encoding => 'UTF8',
    require  => [Class['postgresql::server'], Pg_user['canvas']]
  }

  package { 'libpq-dev':
    ensure => installed
  }
}
class { 'install_postgres': }

class install_core_packages {
  if !defined(Package['build-essential']) {
    package { 'build-essential':
      ensure => installed
    }
  }

  if !defined(Package['git-core']) {
    package { 'git-core':
      ensure => installed
    }
  }
}
class { 'install_core_packages': }

class install_ruby {
  package { ['ruby', 'ruby-dev', 'zlib1g-dev', 'rake', 'rubygems', 'irb', 'libhttpclient-ruby']:
    ensure => installed
  }

  exec { '/usr/bin/gem install bundler --no-rdoc --no-ri':
    unless  => '/usr/bin/gem list | grep bundler',
    user    => 'root',
    require => Package['rubygems']
  }
}
class { 'install_ruby': }

class install_nokogiri_dependencies {
  package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
    ensure => installed
  }
}
class { 'install_nokogiri_dependencies': }

class install_libxmlsec_dependencies {
  package { [libxmlsec1-dev]:
    ensure => installed
  }
}
class { 'install_libxmlsec_dependencies': }

# Required for typheous gem
class install_curl_dependencies {
  package { ['curl', 'libcurl3-dev']:
    ensure => installed
  }
}
class { 'install_curl_dependencies': }

class install_js_dependencies {
  package { ['nodejs', 'coffeescript']:
    ensure => installed
  }
}
class { 'install_js_dependencies': }

