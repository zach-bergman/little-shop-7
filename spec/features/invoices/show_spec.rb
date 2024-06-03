require 'rails_helper'

RSpec.describe 'invoice show' do
  before do
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant, unit_price: 100)

    @customer_1 = create(:customer)

    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_item_1 = create(:invoice_item, item: @item, invoice: @invoice_1, quantity: 10, unit_price: 10)
  end

  describe 'as a merchant' do
    visit merchant_invoice_path(@merchant, @invoice_1)

    expect(page).to have_content(@invoice_1.id)

    within('.item-info') do
      expect(page).to have_content("Status: #{invoice_1.status}")
      expect(page).to have_content("Created at: #{invoice_1.formatted_date}")
      expect(page).to have_content("Customer: #{invoice_1.customer.first_name} #{invoice_1.customer.last_name}")
    end
  end
end
