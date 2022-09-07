require "spec_helper"

describe FieldStrategy::RandomIpAddress do

  RandomIpAddress = FieldStrategy::RandomIpAddress
  let(:field) { DataAnon::Core::Field.new('last_ip', '127.0.0.1', 1, nil) }

  describe 'should return same length value using default text' do

    let(:anonymized_value) { RandomIpAddress.new.anonymize(field) }

    it { anonymized_value.length.should_not be('New Delhi') }
    it { anonymized_value.length.should == 'New Delhi'.length }

  end

  describe 'should return same length value using set text' do

    let(:anonymized_value) { RandomIpAddress.new("Sunit Parekh").anonymize(field) }

    it { anonymized_value.length.should_not be('New Delhi') }

  end


end
