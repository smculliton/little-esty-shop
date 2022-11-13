require './app/poros/holiday'

RSpec.describe Holiday do 
  before(:each) do
    @data = {localName: 'Thanksgiving', date: '2022-11-24'}
  end

  it 'exists' do 
    expect(Holiday.new(@data)).to be_a Holiday
  end

  it 'has a name and date' do 
    thanks = Holiday.new(@data)
    expect(thanks.name).to eq('Thanksgiving')
    expect(thanks.date).to be_a Date
  end

  describe '#create_date' do 
    it 'creates a date from a string' do 
      thanks = Holiday.new({localName: 'Thanksgiving', date: '2022-11-24'})
      date = thanks.create_date('2022-03-13')

      expect(date).to be_a Date
      expect(date.mon).to eq(3)
    end
  end
end 