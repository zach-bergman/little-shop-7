class ChangeDiscountsToBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    rename_table :discounts, :bulk_discounts
  end
end
