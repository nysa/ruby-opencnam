require 'spec_helper'

class DummyExtender
  extend Opencnam::Util
end

describe Opencnam::Util do
  describe '#process_response' do
    context 'when response is OK' do
      let(:ok) { OpencnamOkResponse.new }

      it 'should not raise exceptions' do
        expect { DummyExtender.send(:process_response, ok, 'text') }.to_not(
          raise_error Opencnam::OpencnamError
        )
      end
    end

    context 'when response is not OK' do
      let(:bad) { OpencnamBadResponse.new }

      it 'should raise an error' do
        expect { DummyExtender.send(:process_response, bad, 'text') }.to(
          raise_error Opencnam::OpencnamError
        )
      end
    end

    %w(text jsonp).each do |format|
      context %(when format is "#{format}") do
        let(:ok) { OpencnamOkResponse.new }

        it 'should return a string' do
          DummyExtender.send(:process_response, ok, format).should be_a String
        end
      end
    end

    context 'when format is not "text" or "jsonp"' do
      let(:ok) { OpencnamOkResponse.new }

      it 'should return a Hash' do
        DummyExtender.send(:process_response, ok, 'xml').should be_a Hash
      end
    end
  end

  describe '#parse_response_date' do
    context 'when given valid ISO date string' do
      it 'should return a Time object' do
        date_string = '2013-02-17T01:34:22.501327'
        DummyExtender.send(:parse_response_date, date_string).should be_a Time
      end
    end

    context 'when given invalid ISO date string' do
      it 'should return nil' do
        DummyExtender.send(:parse_response_date, 'abcd').should be_nil
      end
    end

    context 'when given nil' do
      it 'should return nil' do
        DummyExtender.send(:parse_response_date, nil).should be_nil
      end
    end
  end

  describe '#sanitize_and_convert_format' do
    %w(text html pbx).each do |format|
      context %(when given "#{format}") do
        it 'should return "text"' do
          DummyExtender.send(:sanitize_and_convert_format, format).should eq(
            'text'
          )
        end
      end
    end

    %w(json xml yaml).each do |format|
      context %(when given "#{format}") do
        it 'should return "json"' do
          DummyExtender.send(:sanitize_and_convert_format, format).should eq(
            'json'
          )
        end
      end
    end

    context 'when given "jsonp"' do
      it 'should return "jsonp"' do
        DummyExtender.send(:sanitize_and_convert_format, 'jsonp').should eq(
          'jsonp'
        )
      end
    end

    context 'when given an unsupported format' do
      it 'should raise ArgumentError' do
        expect { DummyExtender.send(:sanitize_and_convert_format, 'png') }.to(
          raise_error ArgumentError
        )
      end
    end
  end
end
