require "rails_helper"

RSpec.describe "Admin Merchant New Page" do
  before(:each) do
    visit new_admin_merchant_path
  end

  describe "As an admin, when I visit the Admin Merchant New Page" do
    describe "User Story 29" do
      it "shows a form to create a new merchant" do
        within("div#create_new_merchant_form") do
          expect(page).to have_selector("form")
        end
      end
  
      it "directs back to the admin merchants index page once form is filled out
      and Submit button is clicked" do
        within("div#create_new_merchant_form") do
          fill_in("merchant[name]", with: "Amazingly Awesome Merchant")

          click_button("Submit")

          expect(current_path).to eq(admin_merchants_path)
        end
      end
  
      it "shows the newly created merchant displayed under the 'Disabled Merchants' section
      - Merchant is created with default status of disabled" do
        within("div#create_new_merchant_form") do
          fill_in("merchant[name]", with: "Amazingly Awesome Merchant")

          click_button("Submit")

          expect(current_path).to eq(admin_merchants_path)
        end

        within("div#disabled_merchants") do
          expect(page).to have_content("Amazingly Awesome Merchant")
        end

        within("div#enabled_merchants") do
          expect(page).to_not have_content("Amazingly Awesome Merchant")
        end
      end
    end
  end
end