require 'rails_helper'

RSpec.describe 'Dashboard' do
  before(:each) do
    @name1 = Faker::Name.name
    @merchant1 = Merchant.create(name: @name1)
    visit merchant_dashboard_index_path(@merchant1.id)
  end
  describe 'as a merchant, visiting merchant dashboard' do
    it 'shows the name of merchant' do
      binding.pry
    end
    # As a merchant,
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    # Then I see the name of my merchant
  end
end
