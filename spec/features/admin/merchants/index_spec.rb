require "rails_helper"

RSpec.describe "Admin Merchants Index" do
  before(:each) do
    @merchants = create_list(:merchant, 5)
    @merchant_test = create(:merchant)

    visit admin_merchants_path
  end

  describe "As an admin, when I visit the admin merchants index" do
    describe "User Story 24" do
      it "shows the name of each merchant" do
        within("div#merchants_list") do
          @merchants.each do |merchant|
            expect(page).to have_content(merchant.name)
          end
        end
      end
    end

    describe "User Story 25" do
      it "shows each merchant's name as a link" do
        within("div#merchants_list") do
          @merchants.each do |merchant|
            expect(page).to have_link(merchant.name)
          end
        end
      end

      it "directs to the admin show page when a merchant's name is clicked" do
        click_link(@merchant_test.name)

        expect(current_path).to eq(admin_merchant_path(@merchant_test.id))
      end
    end
  end

  describe "User Story 27" do
    it "has an enable or disable button next to each merchant and when one of the buttons
    is clicked, it redirects back to the index page and the merchant's status has changed" do
      enabled_merchant = create(:merchant, status: 1)
      disabled_merchant = create(:merchant, status: 0)

      within("div#merchants_list") do
        Merchant.all.each do |merchant|
          within("div#merchant_#{merchant.id}") do
            if merchant.enabled?
              expect(page).to have_button("Disable")
              expect(page).to_not have_button("Enable")
              
              click_button("Disable")
              
              expect(current_path).to eq(admin_merchants_path)
              
              expect(page).to have_button("Enable")
              expect(page).to_not have_button("Disable")
            else
              expect(page).to have_button("Enable")
              expect(page).to_not have_button("Disable")

              click_button("Enable")

              expect(current_path).to eq(admin_merchants_path)

              expect(page).to have_button("Disable")
              expect(page).to_not have_button("Enable")
            end
          end 
        end
      end
    end
  end
end