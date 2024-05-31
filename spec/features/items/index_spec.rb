require 'rails_helper'

RSpec.describe 'items index' do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)
    @item_4 = create(:item, merchant: @merchant_2)
  end

  describe 'as a merchant' do
    it 'merchant item index displays a merchants items' do
      visit merchant_items_path(@merchant_1)

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_3.name)
      expect(page).to_not have_content(@item_4.name)
    end

    it 'merchant item index has links to a merchant items show page' do
      visit merchant_items_path(@merchant_1)

      click_link @item_1.name

      expect(current_path).to eq(merchant_item_path(@merchant_1, @item_1))
    end
  end
end
