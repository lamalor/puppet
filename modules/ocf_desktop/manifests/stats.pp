class ocf_desktop::stats {
  user {
    'ocfstats':
      comment => 'OCF Desktop Stats',
      home    => '/opt/stats',
      system  => true,
      groups  => 'sys';
  }

  file {
    '/opt/stats':
      ensure  => directory,
      owner   => ocfstats,
      group   => root,
      mode    => '0700',
      require => User['ocfstats'];

    '/opt/stats/update.sh':
      mode   => '0500',
      owner  => ocfstats,
      source => 'puppet:///modules/ocf_desktop/stats/update.sh';

    '/opt/stats/update-delay.sh':
      mode   => '0500',
      owner  => ocfstats,
      source => 'puppet:///modules/ocf_desktop/stats/update-delay.sh';

    # CA certificate (used to verify server)
    '/opt/stats/ca.crt':
      mode   => '0444',
      owner  => ocfstats,
      source => 'puppet:///modules/ocf_desktop/stats/ca.crt';

    # local machine certificate and key
    '/opt/stats/local.key':
      mode   => '0400',
      owner  => ocfstats,
      source => 'puppet:///private/stats/local.key';

    '/opt/stats/local.crt':
      mode   => '0444',
      owner  => ocfstats,
      source => 'puppet:///private/stats/local.crt';

  }

  cron { 'labstats':
    ensure   => present,
    command  => '/opt/stats/update.sh > /dev/null',
    user     => 'ocfstats',
    weekday  => '*',
    month    => '*',
    monthday => '*',
    hour     => '*',
    minute   => '*';
  }
}