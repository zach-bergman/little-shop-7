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

      expect(page).to have_link("My Items", href: merchant_items_path(@merchant1))
      expect(page).to have_link("My Invoices", href: merchant_invoices_path(@merchant1))
    end
  end
end
