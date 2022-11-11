require 'rails_helper'

RSpec.describe 'the merchant discounts show page' do 
  before(:each) do 
    @edibles = Merchant.create!(name: 'Edible Arrangements')

    @discount1 = @edibles.bulk_discounts.create!(percentage: 20, threshold: 20)
    @discount2 = @edibles.bulk_discounts.create!(percentage: 50, threshold: 70)

    visit edit_merchant_discount_path(@edibles, @discount1)
  end 

  it 'links from the merchant discount show page' do 
    visit merchant_discount_path(@edibles, @discount1)

    click_button 'Edit Bulk Discount'

    expect(current_path).to eq(edit_merchant_discount_path(@edibles, @discount1))
  end

  it 'has a form that updates the percentage and quantity threshold' do 
    fill_in 'Percent Off', with: 40
    fill_in 'Item Threshold', with: 30
    click_button 'Create Bulk Discount'

    expect(current_path).to eq(merchant_discount_path(@edibles, @discount1))
    expect(page).to have_content("40%")
    expect(page).to have_content("30 items")
  end 

  it 'prepopulates with discounts attributes' do 
    expect(page).to have_field('Percent Off', with: 20)
    expect(page).to have_field('Item Threshold', with: 20)
  end
end