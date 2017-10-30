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

package "apache2" do
  action :install
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


template 'var/lib/jenkins/config.xml' do
	source 'config.xml.erb'
	mode '755'
end

template '/etc/default/jenkins' do
	source 'jenkins.erb'
end


service "apache2" do
  action [:enable, :start]
end



service "jenkins" do
  supports [:stop, :start, :restart]
  action [:start, :enable]
end


execute 'activate the jenkins virtual host' do
	command "a2ensite jenkins"
	notifies :restart, 'service[apache2]'
	notifies :restart, 'service[jenkins]'
end

# execute 'clone plugins git repo' do
# 	command "sudo git clone git@github.com:ghariosk/jenkins-plugins.git ~/plugins"
# 	command "sudo mv ~/plugins /var/lib/jenkins/"
# 	notifies :restart, 'service[jenkins]'
# end

# package 'git'
# %w(git credentials ssh-credentials git-client scm-api github github-api github-oauth mailer).each do |plugin|
#   plugin, version = plugin.split('=')
#   jenkins_plugin plugin do
#     version version if version
#     notifies :create, "ruby_block[jenkins_restart_flag]", :immediately
#   end
# end

