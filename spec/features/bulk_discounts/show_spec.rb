require "rails_helper"

RSpec.describe "Merchant Bulk Discount Show Page" do
  describe "User Story 4 - Merchant Bulk Discount Show" do
    describe "As a merchant, when I visit my bulk discount show page" do
      it "shows the bulk discount's quantity threshold and percentage discount" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)
        bulk_discount_2 = BulkDiscount.create!(name: "20%-15", percentage: 20, quantity_threshold: 15, merchant_id: merchant_1.id)

        visit merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_info") do
          expect(page).to have_content("Bulk Discount Name: #{bulk_discount_1.name}")
          expect(page).to have_content("Percentage Discount: #{bulk_discount_1.percentage}%")
          expect(page).to have_content("Quantity Threshold: #{bulk_discount_1.quantity_threshold}")
        end

        expect(page).to_not have_content("#{bulk_discount_2.name}")
        expect(page).to_not have_content("#{bulk_discount_2.quantity_threshold}")
        expect(page).to_not have_content("#{bulk_discount_2.percentage}")
      end
    end
  end

  describe "User Story 5 - Merchant Bulk Discount Edit" do
    describe "As a merchant, when I visit my bulk discount show page" do
      it "shows a link to edit the bulk discount" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)

        visit merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_edit_link") do
          expect(page).to have_link("Edit #{bulk_discount_1.name}")
        end
      end

      it "directs to the edit Bulk Discount page when link is clicked" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)

        visit merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_edit_link") do
          click_link("Edit #{bulk_discount_1.name}")
        end

        expect(current_path).to eq(edit_merchant_bulk_discount(merchant_1.id, bulk_discount_1.id))
      end
    end
  end
end