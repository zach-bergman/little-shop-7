require 'rails_helper'

RSpec.describe 'items index' do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1, status: 1)
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

    it 'item index has options status listed and a button to change status is present' do
      visit merchant_items_path(@merchant_1)

      expect(page).to have_button('Disable')
      expect(@item_1.status).to eq('enabled')
    end

    it "item status button can change an item's status" do
      visit merchant_items_path(@merchant_1)

      expect(@item_1.status).to eq('enabled')
      click_button('Disable')
      expect(@item_2.status).to eq('disabled')
    end

    it 'groups items by status' do
      visit merchant_items_path(@merchant_1)
      expect(page).to have_content('Enabled Items')
      expect(page).to have_content('Disabled Items')

      within('.enabled-items') do
        expect(page).to have_content(@item_1.name)
        expect(page).to_not have_content(@item_2.name)
        expect(page).to_not have_content(@item_3.name)
      end

      within('.disabled-items') do
        expect(page).to_not have_content(@item_1.name)
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_3.name)
      end
    end
    describe 'create a new item' do
      it 'has a link to create a new item' do
        visit merchant_items_path(@merchant_1)

        expect(page).to have_link('Create New Item')

        click_link 'Create New Item'

        expect(current_path).to eq(new_merchant_item_path(@merchant_1))
      end
    end

    describe 'top five items' do
      before do
        @item_5 = create(:item, merchant: @merchant_1, status: 1)
        @item_6 = create(:item, merchant: @merchant_1, status: 1)
        @item_7 = create(:item, merchant: @merchant_1, status: 1)
        @item_8 = create(:item, merchant: @merchant_1, status: 1)
        @item_9 = create(:item, merchant: @merchant_1, status: 1)

        @customer_1 = create(:customer)
        @customer_2 = create(:customer)
        @customer_3 = create(:customer)

        @invoice_1 = create(:invoice, customer: @customer_1)
        @invoice_2 = create(:invoice, customer: @customer_2)
        @invoice_3 = create(:invoice, customer: @customer_3)
        @invoice_4 = create(:invoice, customer: @customer_1)
        @invoice_5 = create(:invoice, customer: @customer_2)
        @invoice_6 = create(:invoice, customer: @customer_3)

        @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 10, unit_price: 10)
        @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 8, unit_price: 9)
        @invoice_item_5 = create(:invoice_item, item: @item_5, invoice: @invoice_5, quantity: 5, unit_price: 5)
        @invoice_item_4 = create(:invoice_item, item: @item_8, invoice: @invoice_4, quantity: 5, unit_price: 4)
        @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 3, unit_price: 3)
        @invoice_item_6 = create(:invoice_item, item: @item_6, invoice: @invoice_6, quantity: 1, unit_price: 1)

        @transaction_1 = create(:transaction, invoice: @invoice_1, result: 0)
        @transaction_2 = create(:transaction, invoice: @invoice_2, result: 0)
        @transaction_3 = create(:transaction, invoice: @invoice_5, result: 0)
        @transaction_4 = create(:transaction, invoice: @invoice_4, result: 0)
        @transaction_5 = create(:transaction, invoice: @invoice_3, result: 0)
        @transaction_6 = create(:transaction, invoice: @invoice_6, result: 0)

        visit merchant_items_path(@merchant_1)
      end
      it 'displays the top five items' do
        within('.top-five-items') do
          expect(page).to have_link(@item_1.name)
          expect(page).to have_link(@item_2.name)
          expect(page).to have_link(@item_3.name)
          expect(page).to have_link(@item_8.name)
          expect(page).to have_link(@item_5.name)
          expect(page).to_not have_link(@item_6.name)
        end
      end
    end
  end
end
