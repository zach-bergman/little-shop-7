require "rails_helper"

RSpec.describe "Admin Invoice Show" do
    before :each do
        @customer = create(:customer, first_name: "John", last_name: "Doe")
        @invoice = create(:invoice, customer: @customer, created_at: Date.new(2019, 7, 18), status: "completed")
    end

    it "should show the invoice, customer, date of creation, and status" do
        visit admin_invoice_path(@invoice)

        expect(page).to have_content("Invoice ##{@invoice.id}")
        expect(page).to have_content("Status: #{@invoice.status}")
        expect(page).to have_content("Created on: Thursday, July 18, 2019")
        expect(page).to have_content("Customer: John Doe")
    end
end