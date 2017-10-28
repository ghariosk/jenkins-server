#
# Cookbook:: jenkins-server
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

apt_repository "webupd8team" do
  uri "http://ppa.launchpad.net/webupd8team/java/ubuntu"
  components ['main']
  distribution node['lsb']['codename']
  keyserver "keyserver.ubuntu.com"
  key "EEA14886"
  deb_src true
end

apt_update 'update' do
	action :update
end

execute "accept-license" do
  command "echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections"
end

package "oracle-java8-installer" do
  action :install
end

package "oracle-java8-set-default" do
  action :install
end

execute "add key" do 
	command "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -"
end

template '/etc/apt/sources.list' do
	source 'sources.list.erb'
	owner 'root'
	group 'root'
end

apt_update 'update' do
	action :update
end


package "jenkins" 

service "jenkins" do
  supports [:stop, :start, :restart]
  action [:start, :enable]
end

package "apache2" do
  action :install
end

service "apache2" do
  action [:enable, :start]
end

execute "enable the proxy" do
	command "a2enmod proxy"
	command " a2enmod proxy_http"
end


template '/etc/apache2/sites-available/jenkins.conf' do
	source 'jenkins.conf.erb'
	owner 'root'
	group 'root'
end

execute 'activate the jenkins virtual host' do
	command "a2ensite jenkins"
	notifies :restart, 'service[apache2]'
	notifies :restart, 'service[jenkins]'
end

