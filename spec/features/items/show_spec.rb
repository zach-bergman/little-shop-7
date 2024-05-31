require 'rails_helper'

RSpec.describe 'items show' do
  before(:each) do
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant)
  end

  describe 'as a merchant' do
    it 'merchant item show page displays item info' do
      visit merchant_item_path(@merchant, @item)

      expect(page).to have_content("Name: #{@item.name}")
      expect(page).to have_content("Description#{@item.description}")
      expect(page).to have_content("Price:#{@item.price}")
    end
  end
end
