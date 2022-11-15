class Invoice < ApplicationRecord
  enum status: { cancelled: 0,  "in progress" => 1, completed: 2}
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end

  def best_invoice_item_discounts
    invoice_items.select('max(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.percentage / 100)) as discount')
                 .joins(:bulk_discounts)
                 .group(:id)
                 .where('invoice_items.quantity >= bulk_discounts.threshold')
  end

  def discount
    InvoiceItem.select('sum(discount) as total_discount').from("(#{best_invoice_item_discounts.to_sql}) as discounts").take.total_discount
  end

  def discounted_revenue
    return total_revenue if discount.nil?

    total_revenue - discount
  end

  def self.unshipped_items
    Invoice.select('invoices.*').joins(:invoice_items).where(status: [0,1]).group('invoices.id').order('created_at ASC') 
  end
end