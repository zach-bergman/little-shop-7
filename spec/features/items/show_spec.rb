require 'rails_helper'

RSpec.describe 'items show' do
  before(:each) do
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant)
  end

  describe 'as a merchant' do
    it 'merchant item show page displays item info' do
      visit merchant_item_path(@merchant, @item)
      save_and_open_page
      expect(page).to have_content(@item.name)
      expect(page).to have_content("Description: #{@item.description}")
      expect(page).to have_content("Price: $#{@item.unit_price.to_f / 100}")
    end

    it 'has a link to update the item' do
      visit merchant_item_path(@merchant, @item)

      click_link 'Update Item'

      expect(current_path).to eq(edit_merchant_item_path(@merchant, @item))
    end
  end
end
