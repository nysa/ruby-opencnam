require 'spec_helper'

class DummyExtender
  extend Opencnam::Util
end

describe Opencnam::Util do
  describe '#parse_iso_date_string' do
    context 'when given a valid ISO date string' do
      it 'should return a Time object' do
        string = '2013-02-17T01:34:22.501327'
        DummyExtender.send(:parse_iso_date_string, string).should be_a Time
      end
    end

    context 'when given an invalid string' do
      it 'should return nil' do
        DummyExtender.send(:parse_iso_date_string, 'abcdef').should eq nil
      end
    end

    context 'when given nil' do
      it 'should return nil' do
        DummyExtender.send(:parse_iso_date_string, nil).should be_nil
      end
    end
  end

  describe '#parse_json' do
    it 'should return a Hash' do
      DummyExtender.send(:parse_json, '{"name":"Nysa"}').should be_a Hash
    end

    it 'should not receive #parse_iso_date_string' do
      DummyExtender.should_not_receive(:parse_iso_date_string)
      DummyExtender.send(:parse_json, '{"name":"Nysa"}')
    end

    context 'when given a JSON string with key created' do
      it 'should receive #parse_iso_date_string' do
        DummyExtender.should_receive(:parse_iso_date_string)
        DummyExtender.send(:parse_json, '{"created":"ISO"}')
      end
    end

    context 'when given a JSON string with key updated' do
      it 'should receive #parse_iso_date_string' do
        DummyExtender.should_receive(:parse_iso_date_string)
        DummyExtender.send(:parse_json, '{"updated":"ISO"}')
      end
    end

    context 'when given a JSON string with keys updated and created' do
      it 'should receive #parse_iso_date_string twice' do
        DummyExtender.should_receive(:parse_iso_date_string).twice
        DummyExtender.send(:parse_json, '{"created":"ISO","updated":"ISO"}')
      end
    end
  end
end
