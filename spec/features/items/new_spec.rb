require 'rails_helper'

RSpec.describe 'items index' do
  before(:each) do
    @merchant_1 = create(:merchant)
  end
  describe 'as a merchant' do
    it 'can create a new item' do
      visit new_merchant_item_path(@merchant_1)

      fill_in 'Name', with: 'New Item'
      fill_in 'Description', with: 'New Description'
      fill_in 'Unit price', with: 100

      click_button 'Create Item'
      expect(current_path).to eq(merchant_items_path(@merchant_1))

      expect(page).to have_content('New Item')
    end
  end
end
