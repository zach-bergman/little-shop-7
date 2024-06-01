require "rails_helper"

RSpec.describe "Admin Merchant Show Page" do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
  end

  describe "As an admin, when I visit the admin merchant show page" do
    describe "User Story 25" do
      it "shows the name of the merchant" do
        visit admin_merchant_path(@merchant_1.id)

        within("div#merchant_name") do
          expect(page).to have_content(@merchant_1.name)
        end
      end
    end
  end
  
  describe "User Story 26" do
    it "shows a link to update the merchant's information, directs to admin merchant edit page" do
      visit admin_merchant_path(@merchant_1.id)
      expect(page).to have_link("Update #{@merchant_1.name}")

      click_link("Update #{@merchant_1.name}")
      expect(current_path).to eq(edit_admin_merchant_path(@merchant_1))

      visit admin_merchant_path(@merchant_2.id)
      expect(page).to have_link("Update #{@merchant_2.name}")

      click_link("Update #{@merchant_2.name}")
      expect(current_path).to eq(edit_admin_merchant_path(@merchant_2))
    end
  end
end