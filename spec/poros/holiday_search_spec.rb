require './app/poros/holiday_search'
require 'webmock/rspec'

RSpec.describe HolidaySearch do 
  before(:each) do 
    body = [
             { localName: 'holiday1', date: '1991-03-13' },
             { localName: 'holiday2', date: '1991-03-13' },
             { localName: 'holiday3', date: '1991-03-13' }
           ].to_json

    stub_request(:get, 'https://date.nager.at/api/v3/NextPublicHolidays/US')
      .to_return(body: body)

    @holidays = HolidaySearch.create_holidays
  end

  it 'creates holiday objects based on api call' do 
    expect(@holidays.length).to eq(3)
    @holidays.each do |holiday|
      expect(holiday).to be_a Holiday
    end
  end 
end