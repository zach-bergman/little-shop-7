class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true

  enum :status, [:disabled, :enabled], validate: true

  def top_five_customers
    customers
    .joins(:transactions)
    .where("result = 0")
    .select("customers.*, count(transactions.id) as transaction_count")
    .group(:id)
    .order("transaction_count desc")
    .limit(5)
  end

  def self.top_five_merchants_by_rev
    # joins(invoices: :transactions)
    # .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue")
    # .where("transactions.result = 0")
    # .group(:id)
    # .order(total_revenue: :DESC)
    # .limit(5)

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
end