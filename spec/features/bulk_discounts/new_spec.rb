require "rails_helper"

RSpec.describe "Merchant Bulk Discount New Page" do
  describe "User Story 2 - Merchant Bulk Discount Create" do
    describe "As a merchant, when I visit my merchant bulk discount new page" do
      it "shows a form to add a new bulk discount" do
        merchant_1 = create(:merchant)

        visit new_merchant_bulk_discount_path(merchant_1.id)

        within("div.new_form") do
          expect(page).to have_selector("form")
        end
      end

      it "redirects back to the merchant bulk discounts index page when form is submitted" do
        merchant_1 = create(:merchant)

        visit new_merchant_bulk_discount_path(merchant_1.id)

        fill_in("Name", with: "30%-15")
        fill_in("Percentage Discount", with: 30)
        fill_in("Quantity Threshold", with: 15)
        click_button("Submit")

        expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1.id))
      end

      it "shows the newly created bulk discount on the index page" do
        merchant_1 = create(:merchant)

        visit merchant_bulk_discounts_path(merchant_1.id)

        within("div.bulk_discounts_list") do
          expect(page).to_not have_content("30%-15")
          expect(page).to_not have_content("Percentage Discount: 30%")
          expect(page).to_not have_content("Quantity Threshold: 15")
        end

        visit new_merchant_bulk_discount_path(merchant_1.id)

        fill_in("Name", with: "30%-15")
        fill_in("Percentage Discount", with: 30)
        fill_in("Quantity Threshold", with: 15)
        click_button("Submit")

        expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1.id))

        within("div.bulk_discounts_list") do
          expect(page).to have_content("30%-15")
          expect(page).to have_content("Percentage Discount: 30%")
          expect(page).to have_content("Quantity Threshold: 15")
        end
      end

      it "returns an error message if bulk discount already exists" do
        merchant_1 = create(:merchant)

        visit new_merchant_bulk_discount_path(merchant_1.id)

        fill_in("Name", with: "30%-15")
        fill_in("Percentage Discount", with: 30)
        fill_in("Quantity Threshold", with: 15)
        click_button("Submit")

        expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1.id))

        within("div.bulk_discounts_list") do
          expect(page).to have_content("30%-15")
          expect(page).to have_content("Percentage Discount: 30%")
          expect(page).to have_content("Quantity Threshold: 15")
        end

        visit new_merchant_bulk_discount_path(merchant_1.id)

        fill_in("Name", with: "30%-15")
        fill_in("Percentage Discount", with: 30)
        fill_in("Quantity Threshold", with: "15")
        click_button("Submit")

        expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_1.id))
        expect(page).to have_content("Error: Name has already been taken, Percentage has already been taken, and Quantity threshold has already been taken")
      end
    end
  end
end