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
    expect(page).to have_content("Created on: Thursday, July 18, 2019")
    expect(page).to have_content("Customer: John Doe")
  end

  it "should show the invoice items" do
    visit admin_invoice_path(@invoice)

    within ".invoice-items" do
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

    expect(page).to have_content("#{@invoice.total_revenue}")
  end
  
  describe "User Story 36" do
    it "shows a select field with the current status selected" do
      visit admin_invoice_path(@invoice)

      expect(page).to have_field(:status, with: "completed")
    end

    it "directs back to the admin invoice show page when status is selected and button is clicked" do
      visit admin_invoice_path(@invoice)

      select("cancelled", from: :status)
      click_button("Update Invoice Status")

      expect(current_path).to eq(admin_invoice_path(@invoice))
    end

    it "shows the updated Invoice status" do
      visit admin_invoice_path(@invoice)

      select("cancelled", from: :status)
      click_button("Update Invoice Status")

      expect(current_path).to eq(admin_invoice_path(@invoice))

      expect(page).to have_field(:status, with: "cancelled")
      expect(page).to_not have_field(:status, with: "completed")
    end

    it "should show the invoice status and the update button" do
        visit admin_invoice_path(@invoice)

        expect(page).to have_select("status", selected: "completed")

        select "completed", from: "status"
        click_button "Update Invoice Status"

        expect(current_path).to eq(admin_invoice_path(@invoice))
        expect(page).to have_select('status', selected: 'completed')
    end
  end

  describe "Bulk Discounts - User Story 8 - Admin Invoice Show Page: Total Revenue and Discounted Revenue" do
    describe "As an admin, when I visit an admin invoice show page" do
      it "shows the total revenue and total discounted revenue from the invoice" do
        merchant = create(:merchant, status: "enabled")
        bulk_discount = BulkDiscount.create!(name: "Bulk Discount A", percentage: 20, quantity_threshold: 2, merchant_id: merchant.id)
        customer = create(:customer)
        invoice = create(:invoice, customer: customer)
        item_1 = create(:item, merchant: merchant, unit_price: 100)
        item_2 = create(:item, merchant: merchant, unit_price: 200)
        invoice_item_1 = create(:invoice_item, invoice: invoice, item: item_1, quantity: 2, unit_price: item_1.unit_price)
        invoice_item_2 = create(:invoice_item, invoice: invoice, item: item_2, quantity: 1, unit_price: item_2.unit_price)

        visit admin_invoice_path(invoice)

        within(".revenues") do
          expect(page).to have_content("Revenue Expected Before and After Bulk Discounts")
          expect(page).to have_content("Total Revenue: $4.00")
          expect(page).to have_content("Total Discounted Revenue: $3.60")
        end
      end
    end
  end
end