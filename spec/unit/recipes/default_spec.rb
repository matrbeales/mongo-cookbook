#
# Cookbook:: mongo
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'mongo::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it "should update all sources" do
      expect(chef_run).to update_apt_update("update")
    end

    it "should add mongo to the sources list" do
      expect(chef_run).to add_apt_repository("mongodb-org")
    end

    it "should install mongod" do
      expect(chef_run).to upgrade_package("mongodb-org")
    end

    it "should enable mongod as a service" do
      expect(chef_run).to enable_service("mongod")
    end

    it "should start mongod as a service" do
      expect(chef_run).to start_service("mongod")
    end

    it "should create a mongod.conf template in /etc/mongod" do
      expect(chef_run).to create_template("/etc/mongod.conf").with_variables(proxy_port: 27017)
    end
  end
end
