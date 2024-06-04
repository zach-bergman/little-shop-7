class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  
  enum :status, [ "pending", "packaged", "shipped" ]

  validates :quantity, presence: true
  validates :unit_price, presence: true

  def price
    unit_price / 100
  end

  def total_cost
    quantity * price
  end
end
