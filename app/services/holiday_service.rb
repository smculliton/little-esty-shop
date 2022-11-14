require 'httparty'
require 'json'

class HolidayService
  def self.public_holidays 
    get_url('https://date.nager.at/api/v3/NextPublicHolidays/US')[0..2]
  end

  def self.get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end