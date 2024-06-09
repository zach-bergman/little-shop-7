class Invoice < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  # belongs_to :bulk_discount, optional: true

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
    total = invoice_items.sum('unit_price * quantity')
    number_to_currency(total / 100.0)
  end
end
