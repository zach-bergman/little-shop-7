class AddBulkDiscountFkToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :bulk_discount_id, :bigint
    add_index :invoices, :bulk_discount_id
    add_foreign_key :invoices, :bulk_discounts
  end
end
