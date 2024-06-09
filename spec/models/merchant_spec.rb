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

  describe "#total_revenue_for_invoice" do
    it 'calculates the total revenue for a merchant from an invoice' do
      merchant = create(:merchant, status: "enabled")
      customer = create(:customer)
      invoice = create(:invoice, customer: customer)
      item_1 = create(:item, merchant: merchant, unit_price: 100)
      item_2 = create(:item, merchant: merchant, unit_price: 200)
      invoice_item_1 = create(:invoice_item, invoice: invoice, item: item_1, quantity: 2, unit_price: item_1.unit_price)
      invoice_item_2 = create(:invoice_item, invoice: invoice, item: item_2, quantity: 1, unit_price: item_2.unit_price)

      expect(merchant.total_revenue_for_invoice(invoice)).to eq(400)
    end
  end


  describe "#total_discounted_revenue_for_invoice" do
    # Example 1
    it "no bulk discounts should be applied" do
      # Merchant A has one Bulk Discount, Bulk Discount A is 20% off 10 items
      merchant_A = create(:merchant, status: "enabled")
      bulk_discount = BulkDiscount.create!(name: "Bulk Discount 1", percentage: 20, quantity_threshold: 10, merchant_id: merchant_A.id)

      # Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 5, Item B is ordered in a quantity of 5
      customer = Customer.create!(first_name: "First", last_name: "Customer")
      invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

      item_A = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 10, status: 1, merchant_id: merchant_A.id)
      item_B = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 5, status: 1, merchant_id: merchant_A.id)

      invoice_item_A = InvoiceItem.create!(quantity: 5, unit_price: item_A.unit_price, status: "shipped", item_id: item_A.id, invoice_id: invoice_A.id)
      invoice_item_B = InvoiceItem.create!(quantity: 5, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)
      transaction = create(:transaction, result: "success", invoice_id: invoice_A.id)

      # no bulk discounts should be applied.
      expect(merchant_A.total_revenue_for_invoice(invoice_A)).to eq(75)
      expect(merchant_A.total_discounted_revenue_for_invoice(invoice_A)).to eq(75) # no discount applied, since one item was not ordered 10 times to meet the quantity threshold of bulk discount.

      # The quantities of items ordered cannot be added together to meet the quantity thresholds, 
      # e.g. a customer cannot order 1 of Item A and 1 of Item B to meet a quantity threshold of 2. They must order 2 or Item A and/or 2 of Item B
    end

    # Example 2
    it "only discounts the item that was ordered enough to meet quantity threshold of bulk discount" do
      # Merchant A has one Bulk Discount, Bulk Discount A is 20% off 10 items
      merchant_A = create(:merchant, status: "enabled")
      bulk_discount = BulkDiscount.create!(name: "Bulk Discount 1", percentage: 20, quantity_threshold: 10, merchant_id: merchant_A.id)

      # Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 10, Item B is ordered in a quantity of 5
      customer = Customer.create!(first_name: "First", last_name: "Customer")
      invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

      item_A = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 10, status: 1, merchant_id: merchant_A.id)
      item_B = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 5, status: 1, merchant_id: merchant_A.id)

      invoice_item_A = InvoiceItem.create!(quantity: 10, unit_price: item_A.unit_price, status: "shipped", item_id: item_A.id, invoice_id: invoice_A.id)
      invoice_item_B = InvoiceItem.create!(quantity: 5, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)
      transaction = create(:transaction, result: "success", invoice_id: invoice_A.id)

      # Item A should be discounted at 20% off. Item B should not be discounted.
      expect(merchant_A.total_revenue_for_invoice(invoice_A)).to eq(125)
      expect(merchant_A.total_discounted_revenue_for_invoice(invoice_A)).to eq(105.0)

      # If the quantity of an item ordered meets or exceeds the quantity threshold, then the percentage discount should apply to that item only. 
      # Other items that did not meet the quantity threshold will not be affected.

      # Item A meets the quantity threshold for the Bulk Discount: 10 x 10 = 100, 100 - 20% = 80
      # Item B does not meet the quantity threshold for the Bulk Discount: 5 x 5 = 25
      # 80 + 25 = 105
    end

    # Example 3
    it "gives correct discounts when merchant has two bulk discounts, and two items order quantity meet the quantity threshold for the two bulk discounts" do
      # Merchant A has two Bulk Discounts, Bulk Discount A is 20% off 10 items, Bulk Discount B is 30% off 15 items
      merchant_A = create(:merchant, status: "enabled")
      bulk_discount_A = BulkDiscount.create!(name: "Bulk Discount 1", percentage: 20, quantity_threshold: 10, merchant_id: merchant_A.id)
      bulk_discount_B = BulkDiscount.create!(name: "Bulk Discount 2", percentage: 30, quantity_threshold: 15, merchant_id: merchant_A.id)

      # Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 12, Item B is ordered in a quantity of 15
      customer = Customer.create!(first_name: "First", last_name: "Customer")
      invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

      item_A = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 10, status: 1, merchant_id: merchant_A.id)
      item_B = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 5, status: 1, merchant_id: merchant_A.id)

      invoice_item_A = InvoiceItem.create!(quantity: 12, unit_price: item_A.unit_price, status: "shipped", item_id: item_A.id, invoice_id: invoice_A.id)
      invoice_item_B = InvoiceItem.create!(quantity: 15, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)
      transaction = create(:transaction, result: "success", invoice_id: invoice_A.id)

      # Item A should discounted at 20% off, and Item B should discounted at 30% off.
      expect(merchant_A.total_revenue_for_invoice(invoice_A)).to eq(195)
      expect(merchant_A.total_discounted_revenue_for_invoice(invoice_A)).to eq(148.5)

      # Item A meets the quantity threshold for Bulk Discount A: 120 - 20% = 96
      # Item B meets the quantity threshold for Bulk Discount B: 75 - 30% = 52.5
      # 96 + 52.5 = 148.5
    end

    # Example 4
    it "Both item_A and item_B should discounted at 20% off. Additionally, there is no scenario where bulk_discount_B can ever be applied" do
      # Merchant A has two Bulk Discounts, Bulk Discount A is 20% off 10 items, Bulk Discount B is 15% off 15 items
      merchant = create(:merchant, status: "enabled")
      bulk_discount_A = BulkDiscount.create!(name: "Bulk Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant.id)
      bulk_discount_B = BulkDiscount.create!(name: "Bulk Discount B", percentage: 15, quantity_threshold: 15, merchant_id: merchant.id)

      # Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 12, Item B is ordered in a quantity of 15
      customer = Customer.create!(first_name: "First", last_name: "Customer")
      invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

      item_A = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 10, status: 1, merchant_id: merchant.id)
      item_B = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 5, status: 1, merchant_id: merchant.id)

      invoice_item_A = InvoiceItem.create!(quantity: 12, unit_price: item_A.unit_price, status: "shipped", item_id: item_A.id, invoice_id: invoice_A.id)
      invoice_item_B = InvoiceItem.create!(quantity: 15, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)
      transaction = create(:transaction, result: "success", invoice_id: invoice_A.id)

      # Both Item A and Item B should discounted at 20% off. Additionally, there is no scenario where Bulk Discount B can ever be applied.
      expect(merchant.total_revenue_for_invoice(invoice_A)).to eq(195)
      expect(merchant.total_discounted_revenue_for_invoice(invoice_A)).to eq(156.0)

      # If an item meets the quantity threshold for multiple bulk discounts, only the one with the greatest percentage discount should be applied

      # Item A meets the quantity threshold for Bulk Discount A: 10 x 12 = 120, 120 - 20% = 96
      # Item B meets the quantity thresold for both Bulk Discount A & B, so is given the greatest percentage discount: 15 x 5 = 75, 75 - 20% = 60
      # 96 + 60 = 156
    end

    # Example 5
    it "item_A1 should discounted at 20% off, and item_A2 should discounted at 30% off. item_B should not be discounted." do
      # Merchant A has two Bulk Discounts, Bulk Discount A is 20% off 10 items, Bulk Discount B is 30% off 15 items
      merchant_A = create(:merchant, status: "enabled")
      bulk_discount_A = BulkDiscount.create!(name: "Bulk Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant_A.id)
      bulk_discount_B = BulkDiscount.create!(name: "Bulk Discount B", percentage: 30, quantity_threshold: 15, merchant_id: merchant_A.id)

      # Merchant B has no Bulk Discounts
      merchant_B = create(:merchant, status: "enabled")
      item_B = Item.create!(name: "Notebook", description: "The best notebook ever", unit_price: 5, status: 1, merchant_id: merchant_B.id)
      
      # Invoice A includes two of Merchant A’s items, Item A1 is ordered in a quantity of 12, Item A2 is ordered in a quantity of 15
      customer = Customer.create!(first_name: "First", last_name: "Customer")
      invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

      item_A1 = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 10, status: 1, merchant_id: merchant_A.id)
      item_A2 = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 5, status: 1, merchant_id: merchant_A.id)

      invoice_item_A1 = InvoiceItem.create!(quantity: 12, unit_price: item_A1.unit_price, status: "shipped", item_id: item_A1.id, invoice_id: invoice_A.id)
      invoice_item_A2 = InvoiceItem.create!(quantity: 15, unit_price: item_A2.unit_price, status: "shipped", item_id: item_A2.id, invoice_id: invoice_A.id)

      # Invoice A also includes one of Merchant B’s items, Item B is ordered in a quantity of 15
      invoice_item_B = InvoiceItem.create!(quantity: 15, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)

      # Item A1 should discounted at 20% off, and Item A2 should discounted at 30% off.
      expect(merchant_A.total_revenue_for_invoice(invoice_A)).to eq(195)
      expect(merchant_A.total_discounted_revenue_for_invoice(invoice_A)).to eq(148.5)
      # Item A1 meets the quantity threshold for Bulk Discount A: 12 x 10 = 120, 120 - 20% = 96
      # Item A2 meets the quantity threshold for Bulk Discount B: 15 x 5 = 75, 75 - 30% = 52.5
      # 96 + 52.5 = 148.5

      # Bulk discounts for one merchant should not affect items sold by another merchant. Item B should not be discounted.
      expect(merchant_B.total_revenue_for_invoice(invoice_A)).to eq(75)
      expect(merchant_B.total_discounted_revenue_for_invoice(invoice_A)).to eq(75) # no discount applied
    end
  end
end
