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
  include heroku
  include atom

  atom::package { 'tabs-to-spaces': }
  atom::package { 'layout-manager': }
  atom::package { 'layout-manager': }

  class { 'ruby::global':
    version => '2.1.3'
  }

  ruby_gem { 'Bundler for all rubies':
    gem     => 'bundler',
    version => '~> 1.0',
    ruby_version => '*'
  }

  # rbenv plugin directory needs to be created
  $plugins_dir = "${boxen::config::home}/rbenv/plugins"
  file { $plugins_dir:
    ensure => "directory",
  }

  # install the rbenv-gem-rehash plugin
  # negates need to run rbenv-rehash
  repository { 'rbenv-gem-rehash':
    source  => 'sstephenson/rbenv-gem-rehash',
    path    => "${$plugins_dir}/rbenv-gem-rehash",
    ensure  => '4d7b92de4bdf549df59c3c8feb1890116d2ea985',
    require => File[$plugins_dir]
  }

  # node versions
  nodejs::version { 'v0.10': }

  # common, useful packages
  package {
    [
     'ack',
     'findutils',
     'gnu-tar',
     'tree',
    ]:
  }

  exec {'Generate SSH key for Github':
    command => "ssh-keygen -t rsa -f /Users/${::luser}/.ssh/id_rsa",
    unless  => "test -e /Users/${::luser}/.ssh/id_rsa"
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
