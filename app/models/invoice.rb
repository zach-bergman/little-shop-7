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

  def total_revenue_for_invoice(merchant)
    merchant.invoice_items
          .joins(:item)
          .where(items: { merchant_id: merchant.id })
          .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def total_discounted_revenue_for_invoice
      invoice_items
        .joins(item: :merchant)
        .joins("LEFT JOIN bulk_discounts ON bulk_discounts.merchant_id = items.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold")
        .select('invoice_items.id, invoice_items.quantity, invoice_items.unit_price, COALESCE(MAX(bulk_discounts.percentage), 0) AS discount')
        .group('invoice_items.id')
        .sum { |ii| ii.unit_price * ii.quantity * (1 - ii.discount / 100.0) }
  end
end