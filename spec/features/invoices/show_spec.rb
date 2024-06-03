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
      expect(page).to have_content("Description: #{@item.description}")
      expect(page).to have_content('Price: $1.0')
    end
  end
end
