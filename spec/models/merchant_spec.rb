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
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values({ disabled: 0, enabled: 1}) }
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
        merchant_7 = create(:merchant, status: 1)
        merchant_8 = create(:merchant, status: 1)
        merchant_9 = create(:merchant, status: 1)
        merchant_10 = create(:merchant, status: 1)
        merchant_11 = create(:merchant, status: 1)
        merchant_12 = create(:merchant, status: 1)
        merchant_13 = create(:merchant, status: 1)
        merchant_14 = create(:merchant, status: 1)

        invoice_7 = create(:invoice, status: 1)
        invoice_8 = create(:invoice, status: 1)
        invoice_9 = create(:invoice, status: 1)
        invoice_10 = create(:invoice, status: 1)
        invoice_11 = create(:invoice, status: 1)
        invoice_12 = create(:invoice, status: 1)
        invoice_13 = create(:invoice, status: 1)
        invoice_14 = create(:invoice, status: 1)

        item_7 = create(:item, merchant_id: merchant_7.id, unit_price: 500)
        item_8 = create(:item, merchant_id: merchant_8.id, unit_price: 500)
        item_9 = create(:item, merchant_id: merchant_9.id, unit_price: 500)
        item_10 = create(:item, merchant_id: merchant_10.id, unit_price: 500)
        item_11 = create(:item, merchant_id: merchant_11.id, unit_price: 500)
        item_12 = create(:item, merchant_id: merchant_12.id, unit_price: 500)
        item_13 = create(:item, merchant_id: merchant_13.id, unit_price: 500)
        item_14 = create(:item, merchant_id: merchant_14.id, unit_price: 500)

        invoice_items_merchant_7 = create(:invoice_item, unit_price: 5000, quantity: 10, invoice_id: invoice_7.id, item_id: item_7.id, merchant: merchant_7, status: 2)
        invoice_items_merchant_8 = create(:invoice_item, unit_price: 3000, quantity: 5, invoice_id: invoice_8.id, item_id: item_8.id, merchant: merchant_8, status: 2)
        invoice_items_merchant_9 = create(:invoice_item, unit_price: 2000, quantity: 6, invoice_id: invoice_9.id, item_id: item_9.id, merchant: merchant_9, status: 2)
        invoice_items_merchant_10 = create(:invoice_item, unit_price: 5000, quantity: 8, invoice_id: invoice_10.id, item_id: item_10.id, merchant: merchant_10, status: 0)
        invoice_items_merchant_11 = create(:invoice_item, unit_price: 6000, quantity: 9, invoice_id: invoice_11.id, item_id: item_11.id, merchant: merchant_11, status: 2)
        invoice_items_merchant_12 = create(:invoice_item, unit_price: 2000, quantity: 2, invoice_id: invoice_12.id, item_id: item_12.id, merchant: merchant_12, status: 2)
        invoice_items_merchant_13 = create(:invoice_item, unit_price: 1000, quantity: 4, invoice_id: invoice_13.id, item_id: item_13.id, merchant: merchant_13, status: 2)
        invoice_items_merchant_14 = create(:invoice_item, unit_price: 1000, quantity: 9, invoice_id: invoice_14.id, item_id: item_14.id, merchant: merchant_14, status: 2)

        create(:transaction, result: 0, invoice_id: invoice_7.id)
        create(:transaction, result: 0, invoice_id: invoice_8.id)
        create(:transaction, result: 0, invoice_id: invoice_9.id)
        create(:transaction, result: 1, invoice_id: invoice_10.id)
        create(:transaction, result: 0, invoice_id: invoice_11.id)
        create(:transaction, result: 0, invoice_id: invoice_12.id)
        create(:transaction, result: 0, invoice_id: invoice_13.id)
        create(:transaction, result: 0, invoice_id: invoice_14.id)

        top_five = Merchant.top_five_merchants_by_rev
        binding.pry

        expect(top_five).to match_array([merchant_7, merchant_11, merchant_14, merchant_9, merchant_8])
    
        expect(top_five.first.total_revenue).to eq(500000)
        expect(top_five.second.total_revenue).to eq(108000)
        expect(top_five.third.total_revenue).to eq(100062)
        expect(top_five.fourth.total_revenue).to eq(81000)
        expect(top_five.fifth.total_revenue).to eq(72000)
      end
    end
  end
end
