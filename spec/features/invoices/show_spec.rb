require 'rails_helper'

RSpec.describe 'invoice show' do
  before do
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant, unit_price: 100)

    @customer_1 = create(:customer)

    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_item_1 = create(:invoice_item, item: @item, invoice: @invoice_1, quantity: 10, unit_price: 10_00)
  end

  describe 'as a merchant' do
    it 'can see the invoice information' do
      visit merchant_invoice_path(@merchant, @invoice_1)

      expect(page).to have_content(@invoice_1.id)

      within('.invoice-info') do
        expect(page).to have_content("Status: #{@invoice_1.status}")
        expect(page).to have_content("Created at: #{@invoice_1.format_date}")
        expect(page).to have_content("Customer: #{@invoice_1.customer.first_name} #{@invoice_1.customer.last_name}")
      end
    end

    it 'displays the items on the invoice for given merchant' do
      visit merchant_invoice_path(@merchant, @invoice_1)

      within('.invoice-items') do
        expect(page).to have_content(@item.name)
        expect(page).to have_content(@invoice_item_1.quantity)
        expect(page).to have_content(@invoice_item_1.price)
        expect(page).to have_content(@invoice_item_1.status)
      end
    end

    it 'only displays information for items on invoice' do
      item_2 = create(:item, merchant: @merchant, unit_price: 2222)
      @invoice_2 = create(:invoice, customer: @customer_1)
      invoice_item_2 = create(:invoice_item, item: item_2, invoice: @invoice_2, quantity: 22, unit_price: 22_222)

      visit merchant_invoice_path(@merchant, @invoice_1)

      within('.invoice-items') do
        expect(page).to have_content(@item.name)
        expect(page).to_not have_content(item_2.name)
        expect(page).to_not have_content(invoice_item_2.quantity)
        expect(page).to_not have_content(invoice_item_2.price)
      end
    end

    it 'displays the total revenue for the invoice' do
      visit merchant_invoice_path(@merchant, @invoice_1)

      save_and_open_page
      within('.total-revenue') do
        expect(page).to have_content('Total Revenue: $100')
      end
    end

    it 'displays a select field to update the invoice status' do
      visit merchant_invoice_path(@merchant, @invoice_1)
      within('.invoice-status') do
        expect(page).to have_content('Status: in progress')
        expect(page).to have_button('Update Invoice Status')
      end
    end
  end
end
