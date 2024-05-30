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

    it 'contains links to the items and invoices' do
      visit merchant_dashboard_index_path(@merchant1.id)

      expect(page).to have_link(merchant_items_index_path(@merchant1))
      expect(page).to have_link(merchant_invoices_index_path(@merchant1))
      # As a merchant,
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      # Then I see link to my merchant items index (/merchants/:merchant_id/items)
      # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
    end
  end
end
