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
        within("div#merchant_names") do
          @merchants.each do |merchant|
            expect(page).to have_content(merchant.name)
          end
        end
      end
    end

    describe "User Story 25" do
      it "shows each merchant's name as a link" do
        within("div#merchant_names") do
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
end