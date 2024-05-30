class Transaction < ApplicationRecord
  belongs_to :invoice
  
  validates :credit_card_number, presence: true
  validates :credit_card_expiration_date, presence: true
  
  enum :result, [:success, :failed], validate: true
end