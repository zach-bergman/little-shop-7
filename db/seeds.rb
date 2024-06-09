# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

merchant_A = Merchant.create!(name: "Merchant A", status: "enabled")
bulk_discount_A = BulkDiscount.create!(name: "Bulk Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant_A.id)
bulk_discount_B = BulkDiscount.create!(name: "Bulk Discount B", percentage: 30, quantity_threshold: 15, merchant_id: merchant_A.id)

# Merchant B has no Bulk Discounts
merchant_B = Merchant.create!(name: "Merchant B", status: "enabled")
item_B = Item.create!(name: "Notebook", description: "The best notebook ever", unit_price: 500, status: 1, merchant_id: merchant_B.id)

# Invoice A includes two of Merchant A’s items, Item A1 is ordered in a quantity of 12, Item A2 is ordered in a quantity of 15
customer = Customer.create!(first_name: "First", last_name: "Customer")
invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

item_A1 = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 1000, status: 1, merchant_id: merchant_A.id)
item_A2 = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 500, status: 1, merchant_id: merchant_A.id)

invoice_item_A1 = InvoiceItem.create!(quantity: 12, unit_price: item_A1.unit_price, status: "shipped", item_id: item_A1.id, invoice_id: invoice_A.id)
invoice_item_A2 = InvoiceItem.create!(quantity: 15, unit_price: item_A2.unit_price, status: "shipped", item_id: item_A2.id, invoice_id: invoice_A.id)

# Invoice A also includes one of Merchant B’s items, Item B is ordered in a quantity of 15
invoice_item_B = InvoiceItem.create!(quantity: 15, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)

transaction = Transaction.create!(credit_card_number: "123456789", credit_card_expiration_date: "08/29/26", result: "success", invoice_id: invoice_A.id)