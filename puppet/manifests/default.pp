$canvas_databases = ['canvas_development', 'canvas_queue_development', 'canvas_test']

# Make sure apt-get -y update runs before anything else.
stage { 'preinstall': before => Stage['main'] }
stage { 'canvas_setup': require => Stage['main'] }
stage { 'canvas_bundle': require => Stage['canvas_setup'] }

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
  package { ['build-essential', 'git-core'] :
    ensure => installed
  }
}
class { 'install_core_packages': }

class install_ruby {
  package {['ruby1.9.1', 'ruby1.9.1-dev', 'zlib1g-dev', 'rake', 'rubygems1.9.1', 'irb', 'libhttpclient-ruby']:
    ensure => installed
  }

  exec { '/usr/bin/update-alternatives --set ruby /usr/bin/ruby1.9.1':
    user    => 'root',
    require => Package['ruby1.9.1'],
    before  => Exec['/usr/bin/gem install bundler -v 1.5.2 --no-rdoc --no-ri']
  }

  exec { '/usr/bin/update-alternatives --set gem /usr/bin/gem1.9.1':
    user    => 'root',
    require => Package['rubygems1.9.1'],
    before  => Exec['/usr/bin/gem install bundler -v 1.5.2 --no-rdoc --no-ri']
  }

  exec { '/usr/bin/gem install bundler -v 1.5.2 --no-rdoc --no-ri':
    unless  => '/usr/bin/gem list | grep bundler',
    user    => 'root',
    require => Package['rubygems1.9.1']
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

class setup_canvas_configs {
  exec { 'copy_configs' :
    cwd     => '/vagrant/canvas-lms',
    command => '/bin/bash -c "for config in amazon_s3 delayed_jobs domain file_store outgoing_mail security scribd external_migration; do cp config/\$config.yml.example config/\$config.yml; done"',
    path    => "/bin"
  }
}
class { 'setup_canvas_configs': stage => canvas_setup }

class setup_canvas_db_config {
  file { '/vagrant/canvas-lms/config/database.yml':
    ensure => present,
    source => 'puppet:///modules/canvas/database.yml';
  }
}
class { 'setup_canvas_db_config': stage => canvas_setup }

class setup_canvas_bundle {
  notify{"Installing canvas gem dependencies... This can take a few minutes.":}
  exec { 'bundle_install' :
    cwd       => '/vagrant/canvas-lms',
    command   => 'bundle install --quiet --without sqlite mysql',
    path      => ["/bin", "/usr/bin", "/usr/local/bin"],
    timeout   => 0,
    logoutput => true,
    loglevel  => debug
  }
}
class { 'setup_canvas_bundle': stage => canvas_bundle }
