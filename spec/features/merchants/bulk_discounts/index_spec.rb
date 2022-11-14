require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'the bulk discounts index' do 
  before(:each) do 
    body = [
             { localName: 'Thanksgiving Day', date: '2022-11-24'}, 
             { localName: 'Christmas Day', date: '2022-12-26'}, 
             { localName: "New Year's Day", date: '2023-01-02'}
           ].to_json

    stub_request(:get, 'https://date.nager.at/api/v3/NextPublicHolidays/US')
      .to_return(body: body)

    @edibles = Merchant.create!(name: 'Edible Arrangements')
    @pot = Merchant.create!(name: 'Vintage Cookware')

    @discount1 = @edibles.bulk_discounts.create!(percentage: 20, threshold: 20)
    @discount2 = @edibles.bulk_discounts.create!(percentage: 50, threshold: 70)
    @discount3 = @pot.bulk_discounts.create!(percentage: 70, threshold: 65)

    visit merchant_discounts_path(@edibles)
  end

  it 'links from the merchant dashboard page' do
    visit "/merchants/#{@edibles.id}/dashboard"

    expect(page).to have_link('My Discounts')
    click_link('My Discounts')
    expect(current_path).to eq("/merchants/#{@edibles.id}/discounts")
  end

  it 'it lists all merchants bulk discounts and their attributes' do 
    expect(page).to_not have_content("#{@discount3.percentage.to_i}%")
    expect(page).to_not have_content("#{@discount3.threshold} items")

    within "#discount-#{@discount1.id}" do 
      expect(page).to have_content("#{@discount1.percentage.to_i}%")
      expect(page).to have_content("#{@discount1.threshold} items")
    end

    within "#discount-#{@discount2.id}" do 
      expect(page).to have_content("#{@discount2.percentage.to_i}%")
      expect(page).to have_content("#{@discount2.threshold} items")
    end
  end

  it 'each bulk discount links to that discounts show page' do 
    within "#discount-#{@discount1.id}" do 
      click_button "See Details"
    end

    expect(current_path).to eq(merchant_discount_path(@edibles, @discount1))
  end

  it 'has a button next to each discount to delete that discount' do 
    within "#discount-#{@discount1.id}" do 
      click_button 'Delete'
    end

    expect(current_path).to eq(merchant_discounts_path(@edibles))
    expect(page).to_not have_content("#{@discount1.percentage}%")
    expect(page).to_not have_content("#{@discount1.threshold} items")
  end

  describe 'upcoming holidays' do 
    it 'displays upcoming holidays' do 
      expect(page).to have_content('Thanksgiving Day - November 24, 2022')
      expect(page).to have_content('Christmas Day - December 26, 2022')
      expect(page).to have_content("New Year's Day - January 02, 2023")
    end

    it 'can create a discount for a holiday' do 
      expect(page).to_not have_content("Thanksgiving Day discount")

      within '#0' do 
        click_button 'Create Discount'
      end

      expect(current_path).to eq(new_merchant_discount_path(@edibles))

      expect(page).to have_field('Name', with: 'Thanksgiving Day discount')
      expect(page).to have_field('Percent Off', with: 30)
      expect(page).to have_field('Item Threshold', with: 2)

      click_button "Create Bulk Discount"

      expect(page).to have_content("Thanksgiving Day discount")
    end

    it 'replaces create discount button with view discount button if holiday discount already created' do 
      td_discount = @edibles.bulk_discounts.create!(name: 'TD discount', percentage: 10.0, threshold: 2, holiday: 'Thanksgiving Day')

      visit merchant_discounts_path(@edibles)

      within '#0' do 
        expect(page).to_not have_button('Create Discount')
        click_button 'View Discount'
      end

      expect(current_path).to eq(merchant_discount_path(@edibles, td_discount))
      expect(page).to have_content(td_discount.name)
    end
  end
end