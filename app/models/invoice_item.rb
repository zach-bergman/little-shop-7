class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  
  enum :status, [ "pending", "packaged", "shipped" ]

  validates :quantity, presence: true
  validates :unit_price, presence: true
end