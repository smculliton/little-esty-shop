class Holiday
  attr_reader :name, :date

  def initialize(data)
    @name = data[:localName]
    @date = create_date(data[:date])
  end

  def create_date(date)
    x = date.split('-').map(&:to_i)
    Date.new(x[0], x[1], x[2])
  end
end