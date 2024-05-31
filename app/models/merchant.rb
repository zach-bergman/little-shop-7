class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def top_five_customers
    customers
      .joins(:transactions)
      .where('result = 0')
      .select('customers.*, count(transactions.id) as transaction_count')
      .group(:id)
      .order('transaction_count desc')
      .limit(5)
  end
end
