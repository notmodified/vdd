pkgs = [
  "php5",
  "php5-gd",
  "php5-mysql",
  "php5-mcrypt",
  "php5-curl",
  "php5-dev",
  "php5-sqlite"
]

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/php5/apache2/conf.d/vdd_php.ini" do
  source "vdd_php.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end

modules = [
  "vdd_xdebug",
  "uploadprogress",
  "pdo_mysql",
  "mongo",
  "memcache",
  "sqlite3"
]

modules.each do |mod|
  bash "enable_php_module_#{mod}" do
    user "root"
    code <<-EOH
    php5enmod #{mod}
    EOH
    not_if { File.exists?("/etc/php5/mods-available/#{mod}.ini") }
  end
end