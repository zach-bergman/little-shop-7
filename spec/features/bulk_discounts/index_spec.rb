require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Index Page" do
  describe "User Story 1 - Bulk Discounts" do
    describe "As a merchant, when I visit my merchant bulk discounts index page" do
      it "shows a list of all bulk discounts including the name, percentage, and quantity threshold,
      and each name is a link to that bulk discount's show page" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)
        bulk_discount_2 = BulkDiscount.create!(name: "20%-10%", percentage: 20, quantity_threshold: 10, merchant_id: merchant_1.id)

        merchant_2 = create(:merchant)
        bulk_discount_3 = BulkDiscount.create!(name: "30%-15", percentage: 30, quantity_threshold: 15, merchant_id: merchant_2.id)

        visit merchant_bulk_discounts_path(merchant_1.id)

        within("div.bulk_discounts_list") do
          expect(page).to have_link(bulk_discount_1.name, href: merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id))
          expect(page).to have_content("Percentage Discount: #{bulk_discount_1.percentage}%")
          expect(page).to have_content("Quantity Threshold: #{bulk_discount_1.quantity_threshold}")

          expect(page).to have_link(bulk_discount_2.name, href: merchant_bulk_discount_path(merchant_1.id, bulk_discount_2.id))
          expect(page).to have_content("Percentage Discount: #{bulk_discount_2.percentage}%")
          expect(page).to have_content("Quantity Threshold: #{bulk_discount_2.quantity_threshold}")
        end
        
        expect(page).to_not have_content(bulk_discount_3.name)
        expect(page).to_not have_content(bulk_discount_3.percentage)
        expect(page).to_not have_content(bulk_discount_3.quantity_threshold)
      end
    end
  end
end