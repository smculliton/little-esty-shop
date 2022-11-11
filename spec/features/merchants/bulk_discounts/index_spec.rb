require 'rails_helper'

RSpec.describe 'the bulk discounts index' do 
  before(:each) do 
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
    expect(page).to_not have_content("#{@discount3.percentage}%")
    expect(page).to_not have_content("#{@discount3.threshold} items")

    within "#discount-#{@discount1.id}" do 
      expect(page).to have_content("#{@discount1.percentage}%")
      expect(page).to have_content("#{@discount1.threshold} items")
    end

    within "#discount-#{@discount2.id}" do 
      expect(page).to have_content("#{@discount2.percentage}%")
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
end