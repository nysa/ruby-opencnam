require 'spec_helper'

describe Opencnam::Client do
  let(:client) { Opencnam::Client.new }

  context 'initialization' do
    it 'should set @use_ssl to false' do
      client.use_ssl?.should be_false
    end

    it 'should set @account_sid to nil' do
      client.account_sid.should be_nil
    end

    it 'should set @auth_token to nil' do
      client.auth_token.should be_nil
    end
  end

  describe '#use_ssl?' do
    context 'when @use_ssl is true' do
      before(:each) { client.use_ssl = true }

      it 'should return true' do
        client.use_ssl?.should be_true
      end
    end

    context 'when @use_ssl is false' do
      before(:each) { client.use_ssl = false }

      it 'should return false' do
        client.use_ssl?.should be_false
      end
    end
  end

  describe '#phone' do
    context 'when using http' do
      it 'should return a string' do
        client.phone('+16502530000').should be_a String
      end
    end

    context 'when using https' do
      it 'should return a string' do
        client.use_ssl = true
        client.phone('+16502530000').should be_a String
      end
    end

    context 'when given option :format => "json"' do
      it 'should return a hash' do
        client.phone('+16502530000', :format => 'json').should be_a Hash
      end
    end
  end
end
