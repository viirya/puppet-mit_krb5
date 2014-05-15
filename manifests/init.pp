
class mit_krb5 (
  $default_realm            = '',
  $default_keytab_name      = '',
  $default_tgs_enctypes     = [],
  $default_tkt_enctypes     = [],
  $permitted_enctypes       = [],
  $allow_weak_crypto        = '',
  $clockskew                = '',
  $ignore_acceptor_hostname = '',
  $k5login_authoritative    = '',
  $k5login_directory        = '',
  $kdc_timesync             = '',
  $kdc_req_checksum_type    = '',
  $ap_req_checksum_type     = '',
  $safe_checksum_type       = '',
  $preferred_preauth_types  = '',
  $ccache_type              = '',
  $dns_lookup_kdc           = '',
  $dns_lookup_realm         = '',
  $dns_fallback             = '',
  $realm_try_domains        = '',
  $extra_addresses          = [],
  $udp_preference_limit     = '',
  $verify_ap_req_nofail     = '',
  $ticket_lifetime          = '',
  $renew_lifetime           = '',
  $noaddresses              = '',
  $forwardable              = '',
  $proxiable                = '',
  $rdns                     = '',
  $plugin_base_dir          = '',
  $krb5_conf_path           = '/etc/krb5.conf',
  $krb5_conf_owner          = 'root',
  $krb5_conf_group          = 'root',
  $krb5_conf_mode           = '0444',
  $install_role             = 'client',
) {
  # SECTION: Parameter validation {
  validate_string(
    $default_realm,
    $default_keytab_name,
    $clockskew,
    $k5login_directory,
    $kdc_timesync,
    $kdc_req_checksum_type,
    $ap_req_checksum_type,
    $safe_checksum_type,
    $preferred_preauth_types,
    $ccache_type,
    $realm_try_domains,
    $udp_preference_limit,
    $ticket_lifetime,
    $renew_lifetime,
    $plugin_base_dir,
    $krb5_conf_path,
    $krb5_conf_owner,
    $krb5_conf_group,
    $krb5_conf_mode,
    $install_role
  )
  # Boolean-type parameters are not type-validated at this time.
  # This allows true/false/'yes'/'no'/'1'/0' to be used.
  #
  # Array-type fields are not validated to allow single items via strings or
  # multiple items via arrays
  if $default_realm == '' {
    fail('default_realm must be set manually or via Hiera')
  }
  # END Parameter validation }

  # SECTION: Resource creation {
  anchor { 'mit_krb5::begin': }
  class { 'mit_krb5::install':
    role => $install_role,
  }
  concat { $krb5_conf_path:
    owner  => $krb5_conf_owner,
    group  => $krb5_conf_group,
    mode   => $krb5_conf_mode,
  }
  concat::fragment { 'mit_krb5::libdefaults':
    target  => $krb5_conf_path,
    order   => '01libdefaults',
    content => template('mit_krb5/libdefaults.erb'),
  }
  anchor { 'mit_krb5::end': }
  # END Resource creation }

  # SECTION: Resource ordering {
  Anchor['mit_krb5::begin'] -> Class['mit_krb5::install'] ->
    Concat[$krb5_conf_path] -> Anchor['mit_krb5::end']
  # END Resource ordering }
}
