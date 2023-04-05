# Fix typo in wordpress config file
exec { 'replace-some-typo':
  provider => shell,
  command  => 'sed -i "s/phpp/php/g" /var/www/html/wp-settings.php'
}
