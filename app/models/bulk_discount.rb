class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates :percentage, presence: true, numericality: true
  validates :quantity_threshold, presence: true, numericality: true
end