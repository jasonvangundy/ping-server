#
# Cookbook Name:: ping-server
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'ping-server::default' do
  
    context 'For a default run' do

        let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

        before do
            stub_command('which nginx').and_return(false)
        end

        it 'converges successfully' do
          chef_run
        end

        it 'provisions nginx' do
            expect(chef_run).to include_recipe('nginx')
        end

        it 'provisions nodejs' do
            expect(chef_run).to include_recipe('nodejs')
            expect(chef_run).to run_execute('npm -g install npm@latest')
        end

        it 'provisions redis' do
            expect(chef_run).to include_recipe('redis::install_from_package')
        end

        it 'templates ping-web.conf for nginx' do
          expect(chef_run).to render_file('/etc/nginx/conf.d/ping-web.conf').with_content(
"server {
    listen 80;

    location = / {
        return 301 http://$host/ping;
    }

    location /ping {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://localhost:3000;
        proxy_read_timeout 90;
    }
}")
        end
  end
end

