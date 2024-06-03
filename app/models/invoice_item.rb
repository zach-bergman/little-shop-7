class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  enum :status, %w[pending packaged shipped]

  def price
    unit_price * 100
  end

  def total_cost
    quantity * price
  end
end
