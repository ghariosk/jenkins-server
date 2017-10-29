#
# Cookbook:: jenkins-server
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'jenkins-server::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should add the repository for Java' do 
      expect(chef_run).to add_apt_repository 'webupd8team'
    end

    it 'installs java-8 installer' do
      expect(chef_run).to install_package "oracle-java8-installer"
    end

   it 'installs java-8 ' do
      expect(chef_run).to install_package "oracle-java8-set-default"
    end

    it 'update' do
      expect(chef_run).to update_apt_update 'update'
    end

    it 'should replace the source.list' do
      expect(chef_run).to create_template '/etc/apt/sources.list'
    end

    it 'should install jenkins' do
      expect(chef_run).to install_package 'jenkins'
    end

    it 'should enable jenkins' do
      expect(chef_run).to enable_service 'jenkins'
    end

    it 'should install apache2' do 
      expect(chef_run).to install_package 'apache2'
    end

    it 'should enable apache2' do
      expect(chef_run).to enable_service 'apache2'
    end
  end
end
