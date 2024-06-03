class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

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

  def top_five
    items
      .joins(invoices: :transactions)
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_sold')
      .where(transactions: { result: 'success' })
      .group('items.id')
      .order(total_sold: :desc)
      .limit(5)
  end
end
