class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  def self.all_enabled
    where(status: 'Enabled')
  end

  def self.all_disabled
    where(status: 'Disabled')
  end

  def top_five_customers
    Customer.select('customers.*, count(transactions.*) as num_transactions').joins(invoices: [:transactions, :items]).where("transactions.result = 0").where("items.merchant_id = ?", self.id).order('num_transactions desc').group(:id).limit(5)
  end

  def incomplete_invoices
    invoices.where(status: 1).distinct.order(:created_at)
  end

  def enabled_items
    items.where("status= ?", "Enabled")
  end

  def disabled_items
    items.where("status= ?", "Disabled")
  end
  
  def most_popular_items
    Item.select('items.*, sum(invoice_items.quantity* invoice_items.unit_price) as revenue').joins(:invoice_items, :transactions).where("transactions.result = 0").where("items.merchant_id = ?", self.id).order('revenue desc').group(:id).limit(5)
  end

  def self.top_five_merchants_by_revenue
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').joins(items: [:invoice_items, :transactions]).where('transactions.result = 0').order('revenue desc').group(:id).limit(5)
  end 

  def total_revenue
    items.joins(:invoice_items, :transactions).where('transactions.result = 0').sum('invoice_items.quantity * invoice_items.unit_price')

  end

  def best_date_of_revenue
    invoices.select("invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .order(revenue: :desc)
    .first 
    .created_at
  end

  def holiday_discount(holiday)
    bulk_discounts.find_by(holiday: holiday)
  end
end