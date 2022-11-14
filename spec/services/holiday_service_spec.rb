require 'rails_helper'
require 'webmock/rspec'

RSpec.describe HolidayService do 
  before(:each) do 
    body = [
            { localName: 'holiday1', date: '1991-03-13'}, 
            { localName: 'holiday2', date: '1991-03-13'}, 
            { localName: 'holiday3', date: '1991-03-13'}
    ].to_json

    stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/US").
      to_return(body: body)
  end

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