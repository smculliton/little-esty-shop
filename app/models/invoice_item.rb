class InvoiceItem < ApplicationRecord
  enum status: { packaged: 0, pending: 1, shipped: 2 }
  belongs_to :invoice 
  belongs_to :item 
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  def bulk_discount
    bulk_discounts.where('bulk_discounts.threshold <= ?', self.quantity).order(percentage: :desc).first
  end
end