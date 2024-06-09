class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  validates :name, presence: true

  enum :status, %i[disabled enabled], validate: true

  def top_five_customers
    customers
      .joins(:transactions)
      .where('result = 0')
      .select('customers.*, count(transactions.id) as transaction_count')
      .group(:id)
      .order('transaction_count desc')
      .limit(5)
  end

  def self.top_five_merchants_by_rev
    joins(:transactions)
    .where("transactions.result = 0")
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue")
    .group(:id)
    .order(total_revenue: :desc)
    .limit(5)
  end

  def top_selling_day
    invoices
    .joins(:invoice_items)
    .select("DATE_TRUNC('day', invoices.created_at) AS date, SUM(invoice_items.quantity * invoice_items.unit_price) AS daily_revenue")
    .group("date")
    .order("daily_revenue DESC, date DESC").first.date
  end

  def top_five_items
    items
      .joins(invoices: :transactions)
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_sold')
      .where(transactions: { result: 'success' })
      .group('items.id')
      .order(total_sold: :desc)
      .limit(5)
  end

  def ready_to_ship
    invoice_items.select('invoice_items.*')
          .where(status: [1, 0])
          .joins(:invoice)
          .order(:created_at)
  end

  def total_revenue_for_invoice(invoice)
    invoice.invoice_items
          .joins(:item)
          .where(items: { merchant_id: self.id })
          .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def total_discounted_revenue_for_invoice(invoice)
    invoice.invoice_items
          .joins(item: :merchant)
          .joins("LEFT JOIN bulk_discounts ON bulk_discounts.merchant_id = items.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold")
          .where(items: { merchant_id: self.id })
          .select('invoice_items.id, invoice_items.quantity, invoice_items.unit_price, COALESCE(MAX(bulk_discounts.percentage), 0) AS discount')
          .group('invoice_items.id')
          .sum { |ii| ii.unit_price * ii.quantity * (1 - ii.discount / 100.0) }
  end
end