require "csv"

namespace :csv_load do

  desc "Destroy All Data" 
  task destroy: :environment do
    InvoiceItem.destroy_all
    Item.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
  end

  desc "Load Customers Data"
  task customers: :environment do
    
    CSV.foreach("db/data/customers.csv", :headers => true) do |row|
      Customer.create!(row.to_hash)
    end
    
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end
  
  desc "Load InvoiceItems Data"
  task invoice_items: :environment do
    CSV.foreach("db/data/invoice_items.csv", :headers => true) do |row|
      InvoiceItem.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  desc "Load Invoices Data"
  task invoices: :environment do

    CSV.foreach("db/data/invoices.csv", :headers => true) do |row|
      Invoice.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  desc "Load Items Data"
  task items: :environment do

    CSV.foreach("db/data/items.csv", :headers => true) do |row|
      Item.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  desc "Load Merchants Data"
  task merchants: :environment do
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
    CSV.foreach("db/data/transactions.csv", :headers => true) do |row|
      Transaction.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  desc "Load All Data"
  task all: [:invoice_items, :items, :transactions, :invoices, :merchants, :customers]
end