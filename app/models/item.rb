class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true
  validates :status, presence: true


  enum status: %i[disabled enabled]

  def best_day
    invoices
      .joins(:invoice_items)
      .where('invoices.status = 1')
      .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as daily_revenue')
      .group(:id)
      .order('daily_revenue DESC', 'created_at DESC')
    created_at.to_date
  end
end
