require "csv"

namespace :csv_load do
  desc "Load Customers Data"
  task customers: :environment do
    Customer.destroy_all
    
    CSV.foreach("db/data/customers.csv", :headers => true) do |row|
      Customer.create!(row.to_hash)
    end
    
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end
  
  desc "Load InvoiceItems Data"
  task invoice_items: :environment do
    InvoiceItem.destroy_all

    CSV.foreach("db/data/invoice_items.csv", :headers => true) do |row|
      InvoiceItem.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  desc "Load Invoices Data"
  task invoices: :environment do
    Invoice.destroy_all

    CSV.foreach("db/data/invoices.csv", :headers => true) do |row|
      Invoice.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  desc "Load Items Data"
  task items: :environment do
    Item.destroy_all

    CSV.foreach("db/data/items.csv", :headers => true) do |row|
      Item.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  desc "Load Merchants Data"
  task merchants: :environment do
    Merchant.destroy_all

    default_status = 'disabled'

    CSV.foreach("db/data/merchants.csv", :headers => true) do |row|
      merchant_attributes = row.to_hash
      merchant_attributes['status'] = default_status

      Merchant.create!(merchant_attributes)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  end

  desc "Load Transactions Data"
  task transactions: :environment do
    Transaction.destroy_all

    CSV.foreach("db/data/transactions.csv", :headers => true) do |row|
      Transaction.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  desc "Load All Data"
  task all: [:invoice_items, :items, :transactions, :invoices, :merchants, :customers]
end