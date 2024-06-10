require 'rails_helper'

RSpec.describe Merchant, type: :model do
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

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many :bulk_discounts}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values({ disabled: 0, enabled: 1 }) }
  end

  describe 'instance methods' do
    describe '#top_five_customers' do
      it 'returns the top five customers who had most successful transcations for merchant' do
        expect(@merchant_1.top_five_customers).to eq([@customer_1, @customer_4, @customer_5, @customer_2, @customer_3])
        expect(@merchant_1.top_five_customers).not_to include(@customer_6)
      end
    end

    describe "#top_selling_day" do
      it "returns the date with the highest sales, if multiple days have the same highest sales, it will show the most recent day" do
        invoice_1 = create(:invoice, created_at: "1994-08-29 12:12:12")
        invoice_2 = create(:invoice, created_at: "2024-06-02 12:12:12")
        invoice_3 = create(:invoice, created_at: "2024-06-02 12:12:12")

        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant_id: merchant_1.id)

        create(:invoice_item, unit_price: 2000, quantity: 5, invoice_id: invoice_1.id, item_id: item_1.id)
        create(:invoice_item, unit_price: 1000, quantity: 5, invoice_id: invoice_2.id, item_id: item_1.id)
        create(:invoice_item, unit_price: 200, quantity: 5, invoice_id: invoice_3.id, item_id: item_1.id)

        create(:transaction, result: 0, invoice_id: invoice_1.id)
        create(:transaction, result: 0, invoice_id: invoice_2.id)
        create(:transaction, result: 0, invoice_id: invoice_3.id)

        ######

        invoice_4 = create(:invoice, created_at: "1994-08-29 12:12:12")
        invoice_5 = create(:invoice, created_at: "2024-06-02 12:12:12")
        invoice_6 = create(:invoice, created_at: "2024-06-02 12:12:12")

        merchant_2 = create(:merchant)

        item_2 = create(:item, merchant_id: merchant_2.id)

        create(:invoice_item, unit_price: 1000, quantity: 2, invoice_id: invoice_4.id, item_id: item_2.id)
        create(:invoice_item, unit_price: 1000, quantity: 2, invoice_id: invoice_5.id, item_id: item_2.id)
        create(:invoice_item, unit_price: 200, quantity: 2, invoice_id: invoice_6.id, item_id: item_2.id)

        create(:transaction, result: 0, invoice_id: invoice_4.id)
        create(:transaction, result: 0, invoice_id: invoice_5.id)
        create(:transaction, result: 0, invoice_id: invoice_6.id)

        expect(merchant_1.top_selling_day).to eq("1994-08-29 00:00:00 UTC")
        expect(merchant_2.top_selling_day).to eq("2024-06-02 00:00:00 UTC")
      end
    end
  end

  describe "Test for User Story 30" do
    describe "::top_five_merchants_by_rev" do
      it "returns the top five merchants sorted by total revenue that had at least one successful transaction" do
        merchant_1 = create(:merchant, name: "One")
        merchant_2 = create(:merchant, name: "two")
        merchant_3 = create(:merchant, name: "three")
        merchant_4 = create(:merchant, name: "four")
        merchant_5 = create(:merchant, name: "five")
        merchant_6 = create(:merchant, name: "six")
        merchant_7 = create(:merchant, name: "seven")

        invoice_1 = create(:invoice)
        invoice_2 = create(:invoice)
        invoice_3 = create(:invoice)
        invoice_4 = create(:invoice)
        invoice_5 = create(:invoice)
        invoice_6 = create(:invoice)
        invoice_7 = create(:invoice)

        item_1 = create(:item, merchant_id: merchant_1.id)
        item_2 = create(:item, merchant_id: merchant_2.id)
        item_3 = create(:item, merchant_id: merchant_3.id)
        item_4 = create(:item, merchant_id: merchant_4.id)
        item_5 = create(:item, merchant_id: merchant_5.id)
        item_6 = create(:item, merchant_id: merchant_6.id)
        item_7 = create(:item, merchant_id: merchant_7.id)

        create(:invoice_item, unit_price: 600000, quantity: 5, invoice_id: invoice_1.id, item_id: item_1.id)
        create(:invoice_item, unit_price: 60000000, quantity: 25, invoice_id: invoice_2.id, item_id: item_2.id)
        create(:invoice_item, unit_price: 5000000, quantity: 6, invoice_id: invoice_3.id, item_id: item_3.id)
        create(:invoice_item, unit_price: 20000000, quantity: 3, invoice_id: invoice_4.id, item_id: item_4.id)
        create(:invoice_item, unit_price: 15000000, quantity: 3, invoice_id: invoice_5.id, item_id: item_5.id)
        create(:invoice_item, unit_price: 10000, quantity: 8, invoice_id: invoice_6.id, item_id: item_6.id)
        create(:invoice_item, unit_price: 500, quantity: 3, invoice_id: invoice_7.id, item_id: item_7.id)

        create(:transaction, result: 0, invoice_id: invoice_1.id)
        create(:transaction, result: 0, invoice_id: invoice_2.id)
        create(:transaction, result: 0, invoice_id: invoice_3.id)
        create(:transaction, result: 0, invoice_id: invoice_4.id)
        create(:transaction, result: 0, invoice_id: invoice_5.id)
        create(:transaction, result: 1, invoice_id: invoice_6.id)
        create(:transaction, result: 0, invoice_id: invoice_7.id)


        top_five = Merchant.top_five_merchants_by_rev

        expect(top_five).to match_array([merchant_2, merchant_4, merchant_5, merchant_3, merchant_1])
    
        expect(top_five.first.total_revenue).to eq(1500000000)
        expect(top_five.second.total_revenue).to eq(60000000)
        expect(top_five.third.total_revenue).to eq(45000000)
        expect(top_five.fourth.total_revenue).to eq(30000000)
        expect(top_five.fifth.total_revenue).to eq(3000000)
      end
    end
  end
  
  describe 'top five items' do
    before do
      @merchant_1 = create(:merchant)

      @item_1 = create(:item, merchant: @merchant_1, status: 1)
      @item_2 = create(:item, merchant: @merchant_1, status: 1)
      @item_3 = create(:item, merchant: @merchant_1, status: 1)
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

      @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 10, unit_price: 10, status: 1)
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 8, unit_price: 9, status: 1)
      @invoice_item_5 = create(:invoice_item, item: @item_5, invoice: @invoice_5, quantity: 5, unit_price: 5, status: 1)
      @invoice_item_4 = create(:invoice_item, item: @item_8, invoice: @invoice_4, quantity: 5, unit_price: 4, status: 1)
      @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 3, unit_price: 3, status: 0)
      @invoice_item_6 = create(:invoice_item, item: @item_6, invoice: @invoice_6, quantity: 1, unit_price: 1, status: 0)

      @transaction_1 = create(:transaction, invoice: @invoice_1, result: 0)
      @transaction_2 = create(:transaction, invoice: @invoice_2, result: 0)
      @transaction_3 = create(:transaction, invoice: @invoice_5, result: 0)
      @transaction_4 = create(:transaction, invoice: @invoice_4, result: 0)
      @transaction_5 = create(:transaction, invoice: @invoice_3, result: 0)
      @transaction_6 = create(:transaction, invoice: @invoice_6, result: 0)
    end
    
    it 'displays the top five items' do
      expect(@merchant_1.top_five_items).to eq([@item_1, @item_2, @item_5, @item_8, @item_3])
    end
  end
  
  describe 'ready_to_ship' do
    it 'returns items that are ready to ship' do
      expect(@merchant_1.ready_to_ship).to eq([@invoice_items_11, @invoice_items_12])
    end
  end
end
