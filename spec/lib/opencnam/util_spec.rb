require 'spec_helper'

class DummyExtender
  extend Opencnam::Util
end

describe Opencnam::Util do
  describe 'process_response' do
    context 'when response is OK' do
      let(:response) { OpencnamOkResponse.new }

      it 'should return a hash' do
        DummyExtender.process_response(response, false).should be_a Hash
      end

      it 'should include a Time value at :updated' do
        hash = DummyExtender.process_response(response, false)
        hash[:updated].should be_a Time
      end

      it 'should include a Time value at :created' do
        hash = DummyExtender.process_response(response, false)
        hash[:created].should be_a Time
      end

      context 'when name_only is true' do
        it 'should return a hash of one item' do
          response.stub(:body).and_return('GOOGLE INC')
          DummyExtender.process_response(response, true).should have(1).item
        end
      end
    end

    context 'when response is not OK' do
      let(:response) { OpencnamBadResponse.new }

      it 'should raise an error' do
        expect { DummyExtender.process_response(response, false) }.to(
          raise_error Opencnam::OpencnamError )
      end
    end
  end
end
