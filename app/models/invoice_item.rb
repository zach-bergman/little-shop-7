class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
  
  enum :status, [ "pending", "packaged", "shipped" ]

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :invoice_id, presence: true
  validates :item_id, presence: true
  validates :status, presence: true

  def price
    unit_price / 100
  end

  def total_cost
    quantity * price
  end

  def applied_discount
    item.merchant.bulk_discounts
    .where("quantity_threshold <= ?", self.quantity)
    .order(percentage: :desc)
    .first
  end
end
