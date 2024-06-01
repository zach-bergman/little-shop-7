require "rails_helper"

RSpec.describe "Admin Merchant Edit Page" do
  before(:each) do
    @merchant_1 = create(:merchant)
  end

  describe "As an admin, when I visit the admin merchant edit page" do
    describe "User Story 26" do
      it "shows a form to edit the merchant's info, with the existing merchant attribute
      info pre-filled in" do
        visit edit_admin_merchant_path(@merchant_1)

        within("div#merchant_edit_form") do
          expect(page).to have_selector("form")
          expect(page).to have_field(:name, with: @merchant_1.name)
        end
      end

      it "redirects back to the admin merchant show page when submit button is clicked,
      showing the updated info, and a flash message stating the info has been successfully updated" do
        visit edit_admin_merchant_path(@merchant_1)

        fill_in(:name, with: "Sweet New Merchant Name")
        click_button("Submit")

        expect(current_path).to eq(admin_merchant_path(@merchant_1))

        within("div#merchant_name") do
          expect(page).to have_content("Sweet New Merchant Name")
        end

        expect(page).to have_content("Sweet New Merchant Name's info updated successfully!")
      end
    end
  end
end