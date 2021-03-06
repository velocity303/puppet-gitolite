class gitolite (
  $admin_key_content,
) {

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
    command => '/home/git/gitolite/install -to /home/git/bin',
    environment => 'HOME=/home/git',
    user    => 'git',
    path    => $::path,
    creates => '/home/git/bin/gitolite',
    require => Vcsrepo['/home/git/gitolite'],
  }

  file { '/home/git/admin_key.pub':
    ensure  => present,
    owner   => 'git',
    content => $admin_key_content,
    before  => Exec['setup_gitolite'],
  }

  exec { 'setup_gitolite':
    command     => '/home/git/bin/gitolite setup -pk /home/git/admin_key.pub',
    environment => 'HOME=/home/git',
    user        => 'git',
    path        => $::path,
    creates     => '/home/git/repositories/gitolite-admin.git',
    require     => Exec['install_gitolite'],
  }

}
