require "rails_helper"

RSpec.describe "Merchant Bulk Discount Edit Page" do
  describe "User Story 5 - Merchant Bulk Discount Edit" do
    describe "As a merchant, when I visit my merchant bulk discount edit page" do
      it "shows a form to edit the bulk discount - prepopulated with current attributes of the bulk discount" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)

        visit edit_merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_edit_form") do
          expect(page).to have_selector("form")
          expect(page).to have_field(:name, with: bulk_discount_1.name)
          expect(page).to have_field(:percentage, with: bulk_discount_1.percentage)
          expect(page).to have_field(:quantity_threshold, with: bulk_discount_1.quantity_threshold)
        end
      end

      it "redirects back to the merchant bulk discount's show page when submit button is clicked" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)

        visit edit_merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_edit_form") do
          fill_in(:name, with: "New Bulk Discount")
          fill_in(:percentage, with: 50)
          fill_in(:quantity_threshold, with: 25)
          click_button("Submit")
        end

        expect(current_path).to eq(merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id))
      end

      it "shows the updated bulk discount attribute on the bulk discount's show page - only updating one attribute" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)

        visit edit_merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_edit_form") do
          fill_in(:name, with: "New Bulk Discount")
          expect(page).to have_field(:percentage, with: bulk_discount_1.percentage)
          expect(page).to have_field(:quantity_threshold, with: bulk_discount_1.quantity_threshold)
          click_button("Submit")
        end

        expect(current_path).to eq(merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id))

        within("div.bulk_discount_info") do
          expect(page).to have_content("Bulk Discount Name: New Bulk Discount")
          expect(page).to have_content("Percentage Discount: #{bulk_discount_1.percentage}%")
          expect(page).to have_content("Quantity Threshold: #{bulk_discount_1.quantity_threshold}")
        end

        expect(page).to have_content("Bulk discount was successfully updated.")
      end

      it "shows the updated bulk discount attributes on the bulk discount's show page - updating all attributes" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)

        visit edit_merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_edit_form") do
          fill_in(:name, with: "New Bulk Discount")
          fill_in(:percentage, with: 50)
          fill_in(:quantity_threshold, with: 25)
          click_button("Submit")
        end

        expect(current_path).to eq(merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id))

        within("div.bulk_discount_info") do
          expect(page).to have_content("Bulk Discount Name: New Bulk Discount")
          expect(page).to have_content("Percentage Discount: 50%")
          expect(page).to have_content("Quantity Threshold: 25")
        end

        expect(page).to have_content("Bulk discount was successfully updated.")
      end

      it "shows a flash message when wrong data is entered into form" do
        merchant_1 = create(:merchant)
        bulk_discount_1 = BulkDiscount.create!(name: "10%-5", percentage: 10, quantity_threshold: 5, merchant_id: merchant_1.id)

        visit edit_merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id)

        within("div.bulk_discount_edit_form") do
          fill_in(:name, with: "New Bulk Discount")
          fill_in(:percentage, with: "Fifty")
          fill_in(:quantity_threshold, with: 25)
          click_button("Submit")
        end

        expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1.id, bulk_discount_1.id))
        expect(page).to have_content("Error: Percentage is not a number")
      end
    end
  end
end