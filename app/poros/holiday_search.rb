require './app/services/holiday_service'
require './app/poros/holiday'

class HolidaySearch
  def self.create_holidays
    HolidayService.public_holidays.map do |holiday|
      Holiday.new(holiday)
    end
  end 
end