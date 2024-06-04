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
    def total_revenue
      total = 0
      invoice_items.each do |invoice_item|
        total += invoice_item.total_cost
      end
      total
    end
  end
end
