require 'spec_helper'

describe Opencnam::Client do
  let(:client) { Opencnam::Client.new }
  before(:each) { client.api_base_protocol = 'http' }

  context 'initialization' do
    it 'should set @api_base' do
      client.api_base.should eq 'api.opencnam.com'
    end

    it 'should set @api_base_protocol to "http"' do
      client.api_base_protocol.should eq 'http'
    end

    it 'should set @account_sid to nil' do
      client.account_sid.should be_nil
    end

    it 'should set @auth_token to nil' do
      client.auth_token.should be_nil
    end
  end

  describe '#api_base_protocol=' do
    it 'should set @api_base_protocol' do
      protocol = 'https'

      expect { client.api_base_protocol = protocol }.to change {
        client.api_base_protocol
      }.from('http').to(protocol)
    end
  end

  describe '#phone' do
    context 'when using http' do
      it 'should return a hash' do
        client.phone('+16502530000').should be_a Hash
      end
    end

    context 'when using https' do
      it 'should return a hash' do
        client.api_base_protocol = 'https'
        client.phone('+16502530000').should be_a Hash
      end
    end

    context 'when given name_only = true' do
      it 'should return a hash' do
        client.phone('+16502530000').should be_a Hash
      end
    end
  end
end
