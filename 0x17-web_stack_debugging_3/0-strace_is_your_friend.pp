# Fix typo in wordpress config file
exec { 'fix-wp-typo':
  provider => shell,
  command  => 'sed -i "s/phpp/php/g" /var/www/html/wp-settings.php'
}

