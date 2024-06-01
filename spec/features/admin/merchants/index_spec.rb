require "rails_helper"

RSpec.describe "Admin Merchants Index" do
  before(:each) do
    @merchants = create_list(:merchant, 5)

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
  end
end