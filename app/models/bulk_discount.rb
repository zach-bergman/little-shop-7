#change name of table to bulk_discounts?
class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :percentage, presence: true, numericality: true
  validates :quantity_threshold, presence: true, numericality: true
end