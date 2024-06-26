class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  validates :name, presence: true
  validates :status, presence: true

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
end