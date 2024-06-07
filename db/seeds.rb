# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

@merchant_1 = Merchant.create!(name: "Merchant 1", status: 1)
@merchant_2 = Merchant.create!(name: "Merchant 2", status: 1)

@bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: @merchant_1.id)

@bulk_discount_2 = BulkDiscount.create!(name: "20%-10", percentage: 20, quantity_threshold: 10, merchant_id: @merchant_1.id)

@bulk_discount_3 = BulkDiscount.create!(name: "30%-15", percentage: 30, quantity_threshold: 15, merchant_id: @merchant_2.id)

