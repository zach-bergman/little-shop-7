class Invoice < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  validates :status, presence: true
  validates :customer_id, presence: true

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
    invoice_items.sum('unit_price * quantity')
  end

  def total_discount_for_invoice
    invoice_items
      .joins(item: {merchant: :bulk_discounts})
      .wherqe("invoice_items.quantity >= bulk_discounts.quantity_threshold")
      .select("invoice_items.*, max(bulk_discounts.percentage / 100.0 * invoice_items.unit_price * invoice_items.quantity) as discount")
      .group("invoice_items.id")
      .sum {|invoice_item| invoice_item.discount}
  end

  def total_discounted_revenue_for_invoice
    total_revenue - total_discount_for_invoice
  end
end