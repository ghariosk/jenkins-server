#
# Cookbook:: jenkins-server
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# package 'python3-software-properties' do 
# 	action :install
# end

# package 'software-properties-common' do 
# 	action :install
# end

#adds the java ppa repository to the server
# apt_repository 'openjdk' do
# 	action :add
# 	uri 'ppa:openjdk-r/ppa'
# 	distribution 'trusty'
# end

# apt_repository 'openjdk' do
# 	action :add
# 	uri 'ppa:webupd8team/java'
# end


# apt_update 'update' do
# 	action :update
# end

# apt_package 'oracle-java8-installer' do
# 	action :install
# end




# apt_package 'openjdk-8-jre' do
# 	action :install
# end

# apt_package 'openjdk-8-jdk' do
# 	action :install
# end




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


# apt_repository "jenkins" do
#   uri "https://pkg.jenkins.io/debian-stable binary/"
#   key "https://pkg.jenkins.io/debian-stable/jenkins.io.key"
 
#   action :add
# end

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
