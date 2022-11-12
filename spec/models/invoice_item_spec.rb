require 'rails_helper'

RSpec.describe InvoiceItem do 
  describe 'relationships' do 
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  before(:each) do 
    @merchant1 = Merchant.create!(name: "Kevin's Illegal goods")
    @item1 = @merchant1.items.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 5000)
    @item2 = @merchant1.items.create!(name: "T-Rex", description: "Skull of a Dinosaur", unit_price: 100000)
    @item3 = @merchant1.items.create!(name: "Hamburger", description: "An illegal burger", unit_price: 100000)

    @discount1 = @merchant1.bulk_discounts.create!(percentage: 10, threshold: 10)
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 20, threshold: 20)

    @customer1 = Customer.create!(first_name: "Sean", last_name: "Culliton")
    @invoice1 = Invoice.create!(status: 1, customer_id: @customer1.id, created_at: "2022-11-01 11:00:00 UTC")

    @invoice_item1 = InvoiceItem.create!(quantity: 10, unit_price: 5000, status: 0, item_id: @item1.id, invoice_id: @invoice1.id)
    @invoice_item2 = InvoiceItem.create!(quantity: 20, unit_price: 5000, status: 0, item_id: @item2.id, invoice_id: @invoice1.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 5, unit_price: 5000, status: 0, item_id: @item3.id, invoice_id: @invoice1.id)
  end

  describe 'instance_methods' do 
    describe '#bulk_discount' do 
      it 'returns the bulk discount that will be applied to this item' do 
        expect(@invoice_item1.bulk_discount).to eq(@discount1)
        expect(@invoice_item2.bulk_discount).to eq(@discount2)
        expect(@invoice_item3.bulk_discount).to eq(nil)
      end
    end
  end
end