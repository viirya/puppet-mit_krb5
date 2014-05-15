# == Class: mit_krb5::install
#
# Install MIT Kerberos v5 client.
#
# === Authors
#
# Patrick Mooney <patrick.f.mooney@gmail.com>
#
# === Copyright
#
# Copyright 2013 Patrick Mooney.
#
class mit_krb5::install($packages = undef, $role = 'client') {
  if $packages {
    if is_array($packages) {
      $install = flatten($packages)
    } else {
      $install = [$packages]
    }
  } else {
    if $role == 'client' {
      # OS-specific defaults
      $install = $::osfamily ? {
        'Archlinux' => ['krb5'],
        'Debian'    => ['krb5-user'],
        'Gentoo'    => ['mit-krb5'],
        'Mandrake'  => ['krb5-workstation'],
        'RedHat'    => ['krb5-workstation'],
        'Suse'      => ['krb5-client'],
      }
    } elsif $role == 'server' {
      $install = $::osfamily ? {
        'Archlinux' => ['krb5'],
        'Debian'    => ['krb5-user', 'krb5-kdc'],
        'Gentoo'    => ['mit-krb5'],
        'Mandrake'  => ['krb5-workstation'],
        'RedHat'    => ['krb5-libs', 'krb5-server', 'krb5-workstation'],
        'Suse'      => ['krb5-client'],
      }
    }  
  }
  ensure_packages($install)
}
