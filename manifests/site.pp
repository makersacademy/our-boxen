require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include sublime_text::v2
  include chrome
  include iterm2::stable

  ruby::version { '2.1.3': }

  # seems to be clobbered by /opt/boxen/repo/.ruby-version
  class { 'ruby::global':
    version => '2.1.3'
  }

  ruby_gem { 'Bundler for all rubies':
    gem     => 'bundler',
    version => '~> 1.0',
    ruby_version => '*'
  }
  
  # node versions
  nodejs::version { 'v0.10': }

  sublime_text::v2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }

  # common, useful packages
  package {
    [
     'ack',
     'findutils',
     'gnu-tar',
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
