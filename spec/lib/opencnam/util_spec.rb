require 'spec_helper'

class DummyExtender
  extend Opencnam::Util
end

describe Opencnam::Util do
  describe 'process_response' do
    context 'when response is OK' do
      let(:ok) { OpencnamOkResponse.new }

      it 'should return a hash' do
        DummyExtender.send(:process_response, ok, false).should be_a Hash
      end

      it 'should include a Time value at :updated' do
        hash = DummyExtender.send(:process_response, ok, false)
        hash[:updated].should be_a Time
      end

      it 'should include a Time value at :created' do
        hash = DummyExtender.send(:process_response, ok, false)
        hash[:created].should be_a Time
      end

      context 'when name_only is true' do
        it 'should return a hash of one item' do
          ok.stub(:body).and_return('GOOGLE INC')
          DummyExtender.send(:process_response, ok, true).should have(1).item
        end
      end
    end

    context 'when response is not OK' do
      let(:bad) { OpencnamBadResponse.new }

      it 'should raise an error' do
        expect { DummyExtender.send(:process_response, bad, false) }.to(
          raise_error Opencnam::OpencnamError)
      end
    end
  end
end
