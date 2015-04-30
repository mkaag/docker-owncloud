<?php
$AUTOCONFIG = array (
  'datadirectory'     => '/var/www/owncloud/data',
  /**
   * Database Parameters
   */
  'dbtype'            => 'mysql',
  'dbname'            => 'owncloud',
  'dbhost'            => 'localhost',
  'dbtableprefix'     => 'oc_',
  'dbuser'            => 'owncloud',
  'dbpassword'        => 'owncloud',
  /**
   * User Experience
   */
  'default_language'  => 'en',
  'defaultapp'        => 'files',
  'enable_avatars'    => true,
  /**
   * Mail Parameters
   */
  'mail_domain'       => 'example.com',
  'mail_from_address' => 'owncloud',
  'mail_smtpdebug'    => false,
  'mail_smtpmode'     => 'sendmail',
  'mail_smtphost'     => '127.0.0.1',
  'mail_smtpport'     => 25,
  'mail_smtpsecure'   => '',
  'mail_smtpauth'     => false,
  'mail_smtpauthtype' => 'LOGIN',
  'mail_smtpname'     => '',
  'mail_smtppassword' => '',
  /**
   * Deleted Items (trash bin)
   */
  'trashbin_retention_obligation' => 30,
  'trashbin_auto_expire'          => true,
  /**
   * ownCloud Verifications
   */
  'appcodechecker'              => true,
  'updatechecker'               => true,
  'has_internet_connection'     => true,
  'check_for_working_webdav'    => true,
  'check_for_working_htaccess'  => true,
  /**
   * Logging
   */
  'log_type'          => 'owncloud',
  'logfile'           => 'owncloud.log',
  'loglevel'          => 2,
  'logdateformat'     => 'F d, Y H:i:s',
  'logtimezone'       => 'Europe/Zurich',
  'log_query'         => false,
  'cron_log'          => true,
  'log_rotate_size'   => true,
  /**
   * Previews
   */
  'enable_previews'   => true,
  /**
   * SSL
   */
  'forcessl'              => false,
  'forceSSLforSubdomains' => false,
  /**
   * Miscellaneous
   */
  'blacklisted_files'   => array('.htaccess'),
  'xframe_restriction'  => true,
  'cipher'              => 'AES-256-CFB',
  'redis'               => array(
    'host'    => 'localhost',
    'port'    => 6379,
    'timeout' => 0.0
  ),
  'filesystem_check_changes' => 1
);