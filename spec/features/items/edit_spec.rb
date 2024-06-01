require 'rails_helper'

Rspec.describe 'items edit' do
  before(:each) do
  end

  describe 'as a merchant' do
    it 'merchant item edit page has a form to edit the item' do
      visit edit_merchant_item_path(@merchant, @item)

      fill_in 'Name', with: 'New Item Name'
      fill_in 'Description', with: 'New Item Description'

      click_button 'Update Item'
      expect(current_path).to eq(merchant_item_path(@merchant, @item))
      expect(page).to have_content('New Item Name')
      expect(page).to have_content('New Item Description')
    end
  end
end
