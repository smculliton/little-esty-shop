require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'the bulk discount new page' do 
  before(:each) do 
    body = [
             { localName: 'Thanksgiving Day', date: '2022-11-24'}, 
             { localName: 'Christmas Day', date: '2022-12-26'}, 
             { localName: "New Year's Day", date: '2023-01-02'}
           ].to_json

    stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/US")
      .to_return(body: body)

    @edibles = Merchant.create!(name: 'Edible Arrangements')

    visit new_merchant_discount_path(@edibles)
  end

  it 'links from the merchant discount index page' do 
    visit merchant_discounts_path(@edibles)

    click_button "Create New Bulk Discount"

    expect(current_path).to eq(new_merchant_discount_path(@edibles))
  end

  it 'has a form to create a new discount' do
    fill_in 'Percent Off', with: 90
    fill_in 'Item Threshold', with: 30
    click_button 'Create Bulk Discount'

    expect(current_path).to eq(merchant_discounts_path(@edibles))
    expect(page).to have_content("90%")
    expect(page).to have_content("30 items")
  end

  describe 'sad paths' do 
    it 'redirects back to page with error if percentage is 100' do
      fill_in 'Percent Off', with: 100
      click_button 'Create Bulk Discount'

      expect(current_path).to eq(new_merchant_discount_path(@edibles))
      expect(page).to have_content('Fields missing or invalid')
    end

    it 'redirects back to page with error if percentage is 0' do
      fill_in 'Percent Off', with: 0
      click_button 'Create Bulk Discount'

      expect(current_path).to eq(new_merchant_discount_path(@edibles))
      expect(page).to have_content('Fields missing or invalid')
    end

    it 'redirects back to page with error if item threshold is 0' do
      fill_in 'Item Threshold', with: 0
      click_button 'Create Bulk Discount'

      expect(current_path).to eq(new_merchant_discount_path(@edibles))
      expect(page).to have_content('Fields missing or invalid')
    end
  end
end