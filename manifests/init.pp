class gitolite (
  $admin_key_content,
) {

  user { 'git':
    ensure     => present,
    home       => '/home/git',
    managehome => true,
  }

  file { '/home/git/bin':
    ensure => directory,
    owner  => 'git',
    group  => 'git',
    before => Exec['install_gitolite'],
  }

  vcsrepo { '/home/git/gitolite':
    ensure   => present,
    user     => 'git',
    provider => git,
    source   => 'git://github.com/sitaramc/gitolite',
  }

  exec { 'install_gitolite':
    command => '/opt/gitolite/install -to /home/git/bin/',
    user    => 'git',
    path    => $::path,
    require => Vcsrepo['/opt/gitolite'],
  }

  file { '/tmp/admin_key.pub':
    ensure  => present,
    owner   => 'git',
    content => $admin_key_content,
    before  => Exec['setup_gitolite'],
  }

  exec { 'setup_gitolite':
    command     => 'gitolite setup -pk /tmp/admin_key.pub',
    environment => 'HOME=$HOME',
    user        => 'git',
    path        => $::path,
    require     => Exec['install_gitolite'],
  }

}
