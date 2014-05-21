
class mit_krb5::kdc_setup {

    $kdc_conf_path = $::osfamily ? {
      'Debian'    => '/etc/krb5kdc',
      'RedHat'    => '/var/kerberos/krb5kdc',
    }

    $create_new_kdc_db_command = $::osfamily ? {
      'Debian'    => 'krb5_newrealm',
      'RedHat'    => 'kdb5_util create -s',
    }

    exec { "run kdb5_util":
        command => "kdb5_util create -s",
        user => "root",
        creates => "${kdc_conf_path}/init_done_tmp",
        alias => "kdb5_init",
        path    => ["/usr/sbin/", "/usr/kerberos/sbin"],
    }

}


