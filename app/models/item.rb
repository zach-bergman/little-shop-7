class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  enum status: %i[disabled enabled]

  def self.top_five
    joins(invoices: :transactions)
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_sold')
      .where(transactions: { result: 'success' })
      .group(:id)
      .order(total_sold: :desc)
      .limit(5)
  end
end
