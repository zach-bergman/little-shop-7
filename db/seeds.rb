# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

@merchant_1 = Merchant.create!(name: "Name", status: 1)
@merchant_2 = Merchant.create!(name: "Name", status: 1)
@merchant_3 = Merchant.create!(name: "Name", status: 1)
@merchant_4 = Merchant.create!(name: "Name", status: 1)
@merchant_5 = Merchant.create!(name: "Name", status: 1)
@merchant_6 = Merchant.create!(name: "Name", status: 1)
@merchant_7 = Merchant.create!(name: "Name", status: 1)
@merchant_8 = Merchant.create!(name: "Name", status: 1)
@merchant_9 = Merchant.create!(name: "Name", status: 1)
@merchant_10 = Merchant.create!(name: "Name", status: 1)

@customer_1 = Customer.create!(first_name: "FirstName", last_name: "LastName")

@invoice_1 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_2 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_3 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_4 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_5 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_6 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_7 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_8 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_9 = Invoice.create!(status: 1, customer_id: @customer_1.id)
@invoice_10 = Invoice.create!(status: 1, customer_id: @customer_1.id)

@item_1 = Item.create!(name: "Pen", description: "Ball Point", unit_price: 3, merchant_id: @merchant_1.id)

@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
@invoice_items_merchant_1 = InvoiceItem.create!(status: 2, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?

@transaction_1 = Transaction.create!(result: 1, invoice_id: @invoice_1.id, credit_card_number: 234, credit_card_expiration_date: 12/1/12)
# create(:transaction, result: 1, invoice_id: @invoice_2.id)
# create(:transaction, result: 1, invoice_id: @invoice_3.id)
# create(:transaction, result: 0, invoice_id: @invoice_4.id)
# create(:transaction, result: 1, invoice_id: @invoice_5.id)
# create(:transaction, result: 1, invoice_id: @invoice_6.id)
# create(:transaction, result: 1, invoice_id: @invoice_7.id)
# create(:transaction, result: 1, invoice_id: @invoice_8.id)