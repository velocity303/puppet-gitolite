class gitolite (
  $admin_key_content,
) {

  vcsrepo { '/opt/gitolite':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/sitaramc/gitolite',
  } 

  exec { 'install_gitolite':
    command => '/opt/gitolite/install -ln',
    path    => $::path,
    require => Vcsrepo['/opt/gitolite'],
  }

  file { '/tmp/admin_key.pub':
    ensure => present,
    content => $admin_key_content,
    before  => Exec['setup_gitolite'],
  }

  exec { 'setup_gitolite':
    command => 'gitolite setup -pk /tmp/admin_key.pub',
    path    => $::path,
    require => Exec['install_gitolite']
  }

}
