require 'spec_helper'

describe Opencnam::Client do
  let(:client) { Opencnam::Client.new }

  describe '#initialize' do
    context 'when options is not given' do
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

    context 'when options is given' do
      let(:options) { {
        :account_sid => 'example-account-sid ',
        :auth_token => 'example-auth-token',
        :use_ssl => true,
      } }
      let(:client) { Opencnam::Client.new(options) }

      it 'should set @use_ssl' do
        client.use_ssl?.should be_true
      end

      it 'should set @account_sid' do
        client.account_sid.should_not be_nil
      end

      it 'should set @auth_token' do
        client.auth_token.should_not be_nil
      end
    end
  end

  describe '#use_ssl?' do
    context 'when @use_ssl is true' do
      it 'should return true' do
        client.use_ssl = true
        client.use_ssl?.should be_true
      end
    end

    context 'when @use_ssl is false' do
      it 'should return false' do
        client.use_ssl = false
        client.use_ssl?.should be_false
      end
    end
  end

  describe '#phone' do
    it 'should return a String' do
      client.phone('+16502530000')
    end

    context 'when given a bad phone number' do
      it 'should raise OpencnamError' do
        expect { client.phone('+abcdefgh') }.to(
          raise_error Opencnam::OpencnamError
        )
      end
    end

    context 'when given :format => :text' do
      it 'should return a String' do
        client.phone('+16502530000', :format => :text).should be_a String
      end
    end

    context 'when given :format => :json' do
      it 'should return a Hash' do
        client.phone('+16502530000', :format => :json).should be_a Hash
      end
    end

    context 'when given an unsupported :format' do
      it 'should raise ArgumentError' do
        expect { client.phone('+16502530000', :format => :xml) }.to(
          raise_error ArgumentError
        )
      end
    end
  end
end
