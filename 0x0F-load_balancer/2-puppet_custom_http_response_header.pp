# Install nginx web server and Add the custom HTTP header X-Served-By

exec {'update':
  provider => shell,
  command  => 'sudo apt-get -y update',
  before   => Exec['install nginx'],
}

exec {'install nginx':
  provider => shell,
  command  => 'sudo apt-get -y install nginx',
  before   => Exec['add header'],
}

exec { 'add header':
  provider    => shell,
  environment => ["HOST=${HOSTNAME}"],
  command     => 'sudo sed -i "s/include \/etc\/nginx\/sites-enabled\/\*;/include \/etc\/nginx\/sites-enabled\/\*;\n\tadd_header X-Served-By \"$HOST\";/" /etc/nginx/nginx.conf',
  before      => Exec['restart nginx'],
}

exec { 'restart nginx':
  provider => shell,
  command  => 'sudo service nginx restart',
}
