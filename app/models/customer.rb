class Customer < ApplicationRecord
  has_many :invoices
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.top_five_customers
    self.joins(:transactions)
    .where("result = 0")
    .select("customers.*, count(transactions.id) as transaction_count")
    .group(:id)
    .order("transaction_count desc")
    .limit(5)
  end
end