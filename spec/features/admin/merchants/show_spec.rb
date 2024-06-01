require "rails_helper"

RSpec.describe "Admin Merchant Show Page" do
  before(:each) do
    @merchant = create(:merchant)

    visit admin_merchant_path(@merchant.id)
  end

  describe "As an admin, when I visit the admin merchant show page" do
    describe "User Story 25" do
      it "shows the name of the merchant" do
        within("div#merchant_name") do
          expect(page).to have_content(@merchant.name)
        end
      end
    end
  end
end