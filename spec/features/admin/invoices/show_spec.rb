require "rails_helper"

RSpec.describe "Admin Invoice Show" do
    before :each do
        @customer = create(:customer, first_name: "John", last_name: "Doe")
        @invoice = create(:invoice, customer: @customer, created_at: Date.new(2019, 7, 18), status: "completed")
        @item1 = create(:item, name: "Item 1")
        @item2 = create(:item, name: "Item 2")
        @invoice_item1 = create(:invoice_item, invoice: @invoice, item: @item1, quantity: 5, unit_price: 10, status: "shipped")
        @invoice_item2 = create(:invoice_item, invoice: @invoice, item: @item2, quantity: 3, unit_price: 15, status: "pending")
    end

    it "should show the invoice, customer, date of creation, and status" do
        visit admin_invoice_path(@invoice)

        expect(page).to have_content("Invoice ##{@invoice.id}")
        expect(page).to have_content("Status: #{@invoice.status}")
        expect(page).to have_content("Created on: Thursday, July 18, 2019")
        expect(page).to have_content("Customer: John Doe")
    end

    it "should show the invoice items" do
        visit admin_invoice_path(@invoice)

        within "#invoice-items" do
            expect(page).to have_content("Item 1")
            expect(page).to have_content("Quantity: 5")
            expect(page).to have_content("Price: $10.00")
            expect(page).to have_content("Status: shipped")

            expect(page).to have_content("Item 2")
            expect(page).to have_content("Quantity: 3")
            expect(page).to have_content("Price: $15.00")
            expect(page).to have_content("Status: pending")
        end
    end

    it "should show the total revenue of the invoice" do
        visit admin_invoice_path(@invoice)

        expect(page).to have_content("Total Revenue: $95.00")
    end

    it "should show the invoice status and the update button" do
        visit admin_invoice_path(@invoice)

        expect(page).to have_select("invoice_status", selected: "in_progress")

        select "completed", from: "invoice_status"
        click_button "Update Invoice Status"

        expect(current_path).to eq(admin_invoice_path(@invoice))
        expect(page).to have_select('invoice_status', selected: 'completed')
    end
end