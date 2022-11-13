require 'rails_helper'

RSpec.describe HolidayService do 
  describe '#public_holidays' do 
    it 'returns the next three public holidays' do 
      expect(HolidayService.public_holidays.length).to eq(3)
    end

    it 'each holiday has a date and name of holiday' do 
      HolidayService.public_holidays.each do |holiday|
        expect(holiday[:date]).to_not eq nil
        expect(holiday[:localName]).to_not eq nil 
      end
    end
  end
end