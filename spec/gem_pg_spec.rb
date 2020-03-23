# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'dvwa::gem_pg' do
  let(:subject) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'should install libpq packages' do
    expect(subject).to install_package('libpq5')
    expect(subject).to install_package('libpq-dev')
  end

  it 'should install pg gem package' do
    expect(subject).to install_gem_package('pg')
  end
end
