class Invoice < ApplicationRecord
  enum status: { cancelled: 0,  "in progress" => 1, completed: 2}
  belongs_to :customer 
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  
  
  def total_revenue #for an invoice 
    invoice_items.sum("quantity * unit_price")
  end

  def discounted_revenue
    sql = invoice_items.select('max(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.percentage / 100)) as discount')
                       .joins(:bulk_discounts)
                       .group(:id)
                       .where('invoice_items.quantity >= bulk_discounts.threshold').to_sql

    discount = InvoiceItem.select('sum(discount) as total_discount').from("(#{sql}) as discounts").take.total_discount

    total_revenue - discount
  end

  def self.unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end
end