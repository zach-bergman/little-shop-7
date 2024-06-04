class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum :status, ['in progress', 'completed', 'cancelled']

  def self.incomplete_invoices
    joins(:invoice_items)
      .where.not(invoice_items: { status: 2 })
      .distinct
      .order(:created_at)
  end

  def format_date
    created_at.strftime('%A, %B %d, %Y')
  end

  def total_revenue
    invoice_items.joins(:item)
                 .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
