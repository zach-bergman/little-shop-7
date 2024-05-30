require 'rails_helper'

RSpec.describe 'Dashboard' do
  before(:each) do
    @merchant1 = Merchant.create(name: Faker::Name.name)
    @merchant2 = Merchant.create(name: Faker::Name.name)
  end

  describe 'as a merchant, visiting merchant dashboard' do
    it 'shows the name of merchant' do
      visit merchant_dashboard_index_path(@merchant1.id)

      expect(page).to have_content(@merchant1.name)
      expect(page).to_not have_content(@merchant2.name)

      visit merchant_dashboard_index_path(@merchant2.id)

      expect(page).to have_content(@merchant2.name)
      expect(page).to_not have_content(@merchant1.name)
    end
  end
end
