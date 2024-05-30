require "rails_helper"

RSpec.describe "Admin Dashboard Index", type: :feature do
  before(:each) do
    # merchant
    @merchant_1 = create(:merchant)
    
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
    @invoice_items_1 = create(:invoice_item, invoice_id: @invoice_for_customer_1.id, item_id: @items_for_merchant_1.first.id, status: 2)
    @invoice_items_2 = create(:invoice_item, invoice_id: @invoice_for_customer_1.id, item_id: @items_for_merchant_1.second.id, status: 2)
    # invoice_items - Customer 2
    @invoice_items_3 = create(:invoice_item, invoice_id: @invoice_for_customer_2.id, item_id: @items_for_merchant_1.first.id, status: 2)
    @invoice_items_4 = create(:invoice_item, invoice_id: @invoice_for_customer_2.id, item_id: @items_for_merchant_1.second.id, status: 2)
    # invoice_items - Customer 3
    @invoice_items_5 = create(:invoice_item, invoice_id: @invoice_for_customer_3.id, item_id: @items_for_merchant_1.second.id, status: 2)
    @invoice_items_6 = create(:invoice_item, invoice_id: @invoice_for_customer_3.id, item_id: @items_for_merchant_1.third.id, status: 2)
    # invoice_items - Customer 4
    @invoice_items_7 = create(:invoice_item, invoice_id: @invoice_for_customer_4.id, item_id: @items_for_merchant_1.third.id, status: 2)
    @invoice_items_8 = create(:invoice_item, invoice_id: @invoice_for_customer_4.id, item_id: @items_for_merchant_1.fourth.id, status: 2)
    # invoice_items - Customer 5
    @invoice_items_9 = create(:invoice_item, invoice_id: @invoice_for_customer_5.id, item_id: @items_for_merchant_1.fourth.id, status: 2)
    @invoice_items_10 = create(:invoice_item, invoice_id: @invoice_for_customer_5.id, item_id: @items_for_merchant_1.fifth.id, status: 2)
    # invoice_items - Customer 6
    @invoice_items_11 = create(:invoice_item, invoice_id: @invoice_for_customer_6.id, item_id: @items_for_merchant_1.first.id, status: 0)
    @invoice_items_12 = create(:invoice_item, invoice_id: @invoice_for_customer_6.id, item_id: @items_for_merchant_1.second.id, status: 0)

    # transactions
    @transactions_invoice_1 = create_list(:transaction, 10, invoice_id: @invoice_for_customer_1.id, result: 0)
    @transactions_invoice_2 = create_list(:transaction, 4, invoice_id: @invoice_for_customer_2.id, result: 0)
    @transactions_invoice_3 = create_list(:transaction, 2, invoice_id: @invoice_for_customer_3.id, result: 0)
    @transactions_invoice_4 = create_list(:transaction, 8, invoice_id: @invoice_for_customer_4.id, result: 0)
    @transactions_invoice_5 = create_list(:transaction, 6, invoice_id: @invoice_for_customer_5.id, result: 0)
    @transactions_invoice_6 = create_list(:transaction, 9, invoice_id: @invoice_for_customer_6.id, result: 1) # failed

    visit admin_dashboard_index_path
  end

  describe "As an admin, when I visit the admin dashboard" do
    it "shows a header - Admin Dashboard" do
      within("div#header") do
        expect(page).to have_content("Admin Dashboard")
      end
    end

    it "shows a link to the admin merchants index" do
      within("div#links") do
        expect(page).to have_link("Merchants")

        click_link("Merchants")

        expect(current_path).to eq admin_merchants_path
      end
    end
    
    it "shows a link to the admin invoices index" do
      within("div#links") do
        expect(page).to have_link("Invoices")
      
        click_link("Invoices")
      
        expect(current_path).to eq admin_invoices_path
      end
    end

    describe "Top Customers" do
      it "shows the names of the top 5 customers with most successful transactions" do
        within("div#top_customers") do
          expect(page).to have_content(@customer_1.name)
          expect(page).to have_content(@customer_4.name)
          expect(page).to have_content(@customer_5.name)
          expect(page).to have_content(@customer_2.name)
        end
      end

      # it "shows the number of successful transactions they have conducted - next to each customer name" do

      # end
    end

  end
end