require 'rails_helper' 

RSpec.describe Invoice do 
  before :each do 
    @merchant1 = Merchant.create!(name: "Kevin's Illegal goods")
    @merchant2 = Merchant.create!(name: "Denver PC parts")

    @customer1 = Customer.create!(first_name: "Sean", last_name: "Culliton")
    @customer2 = Customer.create!(first_name: "Sergio", last_name: "Azcona")
    @customer3 = Customer.create!(first_name: "Emily", last_name: "Port")

    @item1 = @merchant1.items.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 5000)
    @item2 = @merchant1.items.create!(name: "T-Rex", description: "Skull of a Dinosaur", unit_price: 100000)
    @item3 = @merchant2.items.create!(name: "UFO Board", description: "Out of this world MotherBoard", unit_price: 400)
    @item4 = @merchant2.items.create!(name: 'Plastic Explosive', description: 'Its a bomb', unit_price: 1000)

    @invoice1 = Invoice.create!(status: 1, customer_id: @customer2.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer1.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id, created_at: "2022-11-01 11:00:00 UTC")
    
    @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @item1.id, invoice_id: @invoice1.id)
    @invoice_item2 =InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @item2.id, invoice_id: @invoice1.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice2.id)


  end
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end 

  describe "instance methods" do 
    describe '#total_revenue' do 
      it 'can calculate total revenue of an invoice' do 
        expect(@invoice1.total_revenue).to eq(15000.00) 
        expect(@invoice2.total_revenue).to eq(20000.00) 
      end
    end

    describe '#discounted_revenue' do 
      it 'returns discounted revenue of invoice if item quantity qualifies' do 
        @merchant2.bulk_discounts.create!(percentage: 10, threshold: 10)
        @invoice_item4 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)

        expect(@invoice3.discounted_revenue).to eq(18000)
      end

      it 'only discounts when item quantity meets discount threshold' do 
        @merchant2.bulk_discounts.create!(percentage: 10, threshold: 15)
        @invoice_item4 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)

        expect(@invoice3.discounted_revenue).to eq(20000)

        @invoice_item5 = InvoiceItem.create!(quantity: 30, unit_price: 2000, status: 2, item_id: @item4.id, invoice_id: @invoice3.id)

        expect(@invoice3.discounted_revenue).to eq(74000)
      end

      it 'takes only biggest discount when two discounts qualify' do 
        @merchant2.bulk_discounts.create!(percentage: 10, threshold: 10)
        @merchant2.bulk_discounts.create!(percentage: 20, threshold: 10)
        @invoice_item4 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)

        expect(@invoice3.discounted_revenue).to eq(16000)
      end

      it 'takes biggest discount across multiple items that qualify for different discounts' do 
        @merchant2.bulk_discounts.create!(percentage: 10, threshold: 10)
        @merchant2.bulk_discounts.create!(percentage: 20, threshold: 20)
        @invoice_item4 = InvoiceItem.create!(quantity: 20, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)
        @invoice_item5 = InvoiceItem.create!(quantity: 10, unit_price: 1000, status: 2, item_id: @item4.id, invoice_id: @invoice3.id)
        # expected = (20 * 2000 * .8) + (10 * 1000 * .9) = 41,000
        expect(@invoice3.discounted_revenue).to eq(41000)
      end

      it 'doesnt add discounts to items from other merchants' do
        @merchant2.bulk_discounts.create!(percentage: 10, threshold: 10)
        @invoice_item4 = InvoiceItem.create!(quantity: 10, unit_price: 1000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)
        @invoice_item5 = InvoiceItem.create!(quantity: 10, unit_price: 1000, status: 2, item_id: @item1.id, invoice_id: @invoice3.id)
        # expected = ( 10 * 1000 * .9) + (10 * 1000) = 19000
        expect(@invoice3.discounted_revenue).to eq(19000)
      end
    end
  end

  describe 'class methods' do 
    describe '#unshipped_items' do 
      it 'it returns invoices that have unshipped items' do
        expect(Invoice.unshipped_items).to eq([@invoice1, @invoice2])
      end
    end
  end
end