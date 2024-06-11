desc "Load Seed Data"
task load_seeds: :environment do
  merchant_A = Merchant.create!(name: "Merchant A", status: "enabled")
  bulk_discount_A = BulkDiscount.create!(name: "Bulk Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant_A.id)
  bulk_discount_B = BulkDiscount.create!(name: "Bulk Discount B", percentage: 30, quantity_threshold: 15, merchant_id: merchant_A.id)

  merchant_B = Merchant.create!(name: "Merchant B", status: "enabled")
  item_B = Item.create!(name: "Notebook", description: "The best notebook ever", unit_price: 500, status: 1, merchant_id: merchant_B.id)

  customer = Customer.create!(first_name: "First", last_name: "Customer")
  invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

  item_A1 = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 1000, status: 1, merchant_id: merchant_A.id)
  item_A2 = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 500, status: 1, merchant_id: merchant_A.id)

  invoice_item_A1 = InvoiceItem.create!(quantity: 12, unit_price: item_A1.unit_price, status: "shipped", item_id: item_A1.id, invoice_id: invoice_A.id)
  invoice_item_A2 = InvoiceItem.create!(quantity: 15, unit_price: item_A2.unit_price, status: "shipped", item_id: item_A2.id, invoice_id: invoice_A.id)

  invoice_item_B = InvoiceItem.create!(quantity: 15, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)

  transaction = Transaction.create!(credit_card_number: "123456789", credit_card_expiration_date: "08/29/26", result: "success", invoice_id: invoice_A.id)
end