require 'rails_helper'

RSpec.describe 'Dashboard' do
  before(:each) do
    # merchant
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    # customers
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)

    # 10 items created, associated with merchant 1
    @items_for_merchant_1 = create_list(:item, 10, merchant_id: @merchant_1.id)

    # invoices created for each customer
    @invoice_for_customer_1 = create(:invoice, customer_id: @customer_1.id, status: 1) # completed
    @invoice_for_customer_2 = create(:invoice, customer_id: @customer_2.id, status: 1)
    @invoice_for_customer_3 = create(:invoice, customer_id: @customer_3.id, status: 1)
    @invoice_for_customer_4 = create(:invoice, customer_id: @customer_4.id, status: 1)
    @invoice_for_customer_5 = create(:invoice, customer_id: @customer_5.id, status: 1)
    @invoice_for_customer_6 = create(:invoice, customer_id: @customer_6.id, status: 2) # cancelled

    # invoice_items - Customer 1
    @invoice_items_1 = create(:invoice_item, invoice_id: @invoice_for_customer_1.id,
                                             item_id: @items_for_merchant_1.first.id, status: 2)
    @invoice_items_2 = create(:invoice_item, invoice_id: @invoice_for_customer_1.id,
                                             item_id: @items_for_merchant_1.second.id, status: 2)
    # invoice_items - Customer 2
    @invoice_items_3 = create(:invoice_item, invoice_id: @invoice_for_customer_2.id,
                                             item_id: @items_for_merchant_1.first.id, status: 2)
    @invoice_items_4 = create(:invoice_item, invoice_id: @invoice_for_customer_2.id,
                                             item_id: @items_for_merchant_1.second.id, status: 2)
    # invoice_items - Customer 3
    @invoice_items_5 = create(:invoice_item, invoice_id: @invoice_for_customer_3.id,
                                             item_id: @items_for_merchant_1.second.id, status: 2)
    @invoice_items_6 = create(:invoice_item, invoice_id: @invoice_for_customer_3.id,
                                             item_id: @items_for_merchant_1.third.id, status: 2)
    # invoice_items - Customer 4
    @invoice_items_7 = create(:invoice_item, invoice_id: @invoice_for_customer_4.id,
                                             item_id: @items_for_merchant_1.third.id, status: 2)
    @invoice_items_8 = create(:invoice_item, invoice_id: @invoice_for_customer_4.id,
                                             item_id: @items_for_merchant_1.fourth.id, status: 2)
    # invoice_items - Customer 5
    @invoice_items_9 = create(:invoice_item, invoice_id: @invoice_for_customer_5.id,
                                             item_id: @items_for_merchant_1.fourth.id, status: 2)
    @invoice_items_10 = create(:invoice_item, invoice_id: @invoice_for_customer_5.id,
                                              item_id: @items_for_merchant_1.fifth.id, status: 2)
    # invoice_items - Customer 6
    @invoice_items_11 = create(:invoice_item, invoice_id: @invoice_for_customer_6.id,
                                              item_id: @items_for_merchant_1.first.id, status: 0)
    @invoice_items_12 = create(:invoice_item, invoice_id: @invoice_for_customer_6.id,
                                              item_id: @items_for_merchant_1.second.id, status: 0)

    # transactions
    @transactions_invoice_1 = create_list(:transaction, 10, invoice_id: @invoice_for_customer_1.id, result: 0)
    @transactions_invoice_2 = create_list(:transaction, 4, invoice_id: @invoice_for_customer_2.id, result: 0)
    @transactions_invoice_3 = create_list(:transaction, 2, invoice_id: @invoice_for_customer_3.id, result: 0)
    @transactions_invoice_4 = create_list(:transaction, 8, invoice_id: @invoice_for_customer_4.id, result: 0)
    @transactions_invoice_5 = create_list(:transaction, 6, invoice_id: @invoice_for_customer_5.id, result: 0)
    @transactions_invoice_6 = create_list(:transaction, 9, invoice_id: @invoice_for_customer_6.id, result: 1) # failed
  end

  describe 'as a merchant, visiting merchant dashboard' do
    it 'shows the name of merchant' do
      visit merchant_dashboard_index_path(@merchant_1)

      expect(page).to have_content(@merchant_1.name)
      expect(page).to_not have_content(@merchant_2.name)

      visit merchant_dashboard_index_path(@merchant_2.id)

      expect(page).to have_content(@merchant_2.name)
      expect(page).to_not have_content(@merchant_1.name)
    end

    it 'contains links to the items and invoices' do
      visit merchant_dashboard_index_path(@merchant_1.id)

      expect(page).to have_link('Items', href: merchant_items_path(@merchant_1))
      expect(page).to have_link('Invoices', href: merchant_invoices_path(@merchant_1))
    end

    it 'shows top 5 customers by largest number of successful transactions' do
      visit merchant_dashboard_index_path(@merchant_1.id)

      within('div#fav_customers') do
        expect(page).to have_content("#{@customer_1.first_name} #{@customer_1.last_name} - 20 purchases") # these transaction_counts are doubled??
        expect(page).to have_content("#{@customer_4.first_name} #{@customer_4.last_name} - 16 purchases")
        expect(page).to have_content("#{@customer_5.first_name} #{@customer_5.last_name} - 12 purchases")
        expect(page).to have_content("#{@customer_2.first_name} #{@customer_2.last_name} - 8 purchases")
        expect(page).to have_content("#{@customer_3.first_name} #{@customer_3.last_name} - 4 purchases")
        expect(page).to_not have_content(@customer_6.first_name)
      end
    end

    it 'shows the items ready to be shipped' do
      visit merchant_dashboard_index_path(@merchant_1.id)
      save_and_open_page
      within('div#items_ready_to_ship') do
        expect(page).to have_content(@items_for_merchant_1.first.name)
        expect(page).to have_content(@items_for_merchant_1.second.name)
        expect(page).to have_content(@items_for_merchant_1.third.name)
        expect(page).to have_content(@items_for_merchant_1.fourth.name)
        expect(page).to_not have_content(@items_for_merchant_1.fifth.name)
      end
    end
  end
end
