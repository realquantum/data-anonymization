require "spec_helper"
require 'nokogiri'
describe FieldStrategy::LoremIpsumHtml do

  LoremIpsumHtml = FieldStrategy::LoremIpsumHtml
  let(:field) { DataAnon::Core::Field.new('city', '<b>Kansas City<img src="https://kansascity1.com/640/480/building"></b>', 1, nil) }

  describe 'should return same length value using default text' do

    let(:anonymized_value) { LoremIpsumHtml.new.anonymize(field) }

    it { anonymized_value.should_not be('<b>Kansas City<img src="https://kansascity1.com/640/480/building"></b>') }
    it { anonymized_value.length.should == '<b>Kansas City<img src="https://kansascity1.com/640/480/building"></b>'.length }

  end

  describe 'should return same length value using set text' do

    let(:anonymized_value) { LoremIpsumHtml.new('<b>Kansas City<img src="https://kansascity1.com/640/480/building"></b>').anonymize(field) }

    it { anonymized_value.length.should be('<b>Kansas City<img src="https://kansascity1.com/640/480/building"></b>'.length) }

  end

  describe 'should change all images to use LoremFlickr' do

    let(:anonymized_value) { LoremIpsumHtml.new.anonymize(field) }

    it {
      nok = Nokogiri::HTML.fragment(anonymized_value)
      imgs_with_loremflickr = 0
      nok.xpath("/img").each do |img|
        if img.attr('src') =~ /loremflickr/
          imgs_with_loremflickr += 1
        end
      end
      imgs_with_loremflickr > 0
    }

  end


end
