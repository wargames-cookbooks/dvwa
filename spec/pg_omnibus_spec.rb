# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'dvwa::pg_omnibus' do
  let(:subject) do
    ChefSpec::SoloRunner.new(
      file_cache_path: '/var/chef/cache').converge(described_recipe)
  end

  it 'should copy bash script file' do
    expect(subject).to create_cookbook_file(
      '/var/chef/cache/pg-chef-omnibus.sh')
      .with(source: 'pg-chef-omnibus.sh',
            mode: '0755')
  end

  it 'should execut bash script' do
    expect(subject).to run_execute('/var/chef/cache/pg-chef-omnibus.sh')
  end
end
