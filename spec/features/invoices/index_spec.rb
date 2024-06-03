require 'rails_helper'

RSpec.describe 'Invoices Index' do
  before do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @customer_1 = create(:customer)
    @customer_2 = create(:customer)

    @item_1 = create(:item, merchant: @merchant_1, status: 1)
    @item_2 = create(:item, merchant: @merchant_1, status: 1)
    @item_3 = create(:item, merchant: @merchant_2, status: 1)

    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_2)
    @invoice_3 = create(:invoice, customer: @customer_2)

    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 10, unit_price: 10)
    @invoice_item_1 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 10, unit_price: 10)
    @invoice_item_1 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 10, unit_price: 10)
  end

  describe 'as a merchant' do
    it 'lists all invoices that include one of merchants items' do
      visit merchant_invoices_path(@merchant_1)

      within('.invoices-list') do
        expect(page).to have_link("#{@invoice_1.id}")
        expect(page).to have_link("#{@invoice_2.id}")
        expect(page).to_not have_link("#{@invoice_3.id}")
      end
    end
  end
end
