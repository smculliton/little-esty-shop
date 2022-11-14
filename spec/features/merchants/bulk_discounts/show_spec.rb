require 'rails_helper'

RSpec.describe 'the bulk discounts show page' do 
  before(:each) do 
    @edibles = Merchant.create!(name: 'Edible Arrangements')

    @discount1 = @edibles.bulk_discounts.create!(percentage: 20, threshold: 20)
    @discount2 = @edibles.bulk_discounts.create!(percentage: 50, threshold: 70)

    visit merchant_discount_path(@edibles, @discount1)
  end

  it 'shows the quantity threshold and percentage discount' do 
    expect(page).to have_content(@discount1.percentage.to_i)
    expect(page).to have_content(@discount1.threshold)
    expect(page).to_not have_content(@discount2.percentage.to_i)
    expect(page).to_not have_content(@discount2.threshold)
  end
end