require 'rails_helper'

RSpec.describe 'the bulk discounts index' do 
  before(:each) do 
    @edibles = Merchant.create!(name: 'Edible Arrangements')
    visit "/merchants/#{@edibles.id}/discounts"
  end

  it 'links from the merchant dashboard page' do
    visit "/merchants/#{@edibles.id}/dashboard"

    expect(page).to have_link('My Discounts')
    click_link('My Discounts')
    expect(current_path).to eq("/merchants/#{@edibles.id}/discounts")
  end
end