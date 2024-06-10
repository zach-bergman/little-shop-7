require 'rails_helper'

RSpec.describe Invoice, type: :model do
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
    @customer_7 = create(:customer)

    # 10 items created, associated with merchant 1
    @items_for_merchant_1 = create_list(:item, 10, merchant_id: @merchant_1.id)

    # invoices created for each customer
    @invoice_for_customer_1 = create(:invoice, customer_id: @customer_1.id, status: 1) # completed
    @invoice_for_customer_2 = create(:invoice, customer_id: @customer_2.id, status: 1)
    @invoice_for_customer_3 = create(:invoice, customer_id: @customer_3.id, status: 1)
    @invoice_for_customer_4 = create(:invoice, customer_id: @customer_4.id, status: 1)
    @invoice_for_customer_5 = create(:invoice, customer_id: @customer_5.id, status: 1)
    @invoice_for_customer_6 = create(:invoice, customer_id: @customer_6.id, status: 2) # cancelled
    @invoice_for_customer_7 = create(:invoice, customer_id: @customer_7.id, status: 2) # cancelled

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
    # invoice_items - Customer 7
    @invoice_items_13 = create(:invoice_item, invoice_id: @invoice_for_customer_7.id, item_id: @items_for_merchant_1.third.id, status: 0)
    @invoice_items_14 = create(:invoice_item, invoice_id: @invoice_for_customer_7.id, item_id: @items_for_merchant_1.fourth.id, status: 0)

    # transactions
    @transactions_invoice_1 = create_list(:transaction, 10, invoice_id: @invoice_for_customer_1.id, result: 0)
    @transactions_invoice_2 = create_list(:transaction, 4, invoice_id: @invoice_for_customer_2.id, result: 0)
    @transactions_invoice_3 = create_list(:transaction, 2, invoice_id: @invoice_for_customer_3.id, result: 0)
    @transactions_invoice_4 = create_list(:transaction, 8, invoice_id: @invoice_for_customer_4.id, result: 0)
    @transactions_invoice_5 = create_list(:transaction, 6, invoice_id: @invoice_for_customer_5.id, result: 0)
    @transactions_invoice_6 = create_list(:transaction, 9, invoice_id: @invoice_for_customer_6.id, result: 1) # failed
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    # it { should belong_to :bulk_discount }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values({ 'in progress' => 0, 'completed' => 1, 'cancelled' => 2 }) }
  end

  describe "class methods" do
    describe ".incomplete_invoices" do
      it "returns invoices with items that have not been shipped" do
        incomplete_invoices_list = Invoice.incomplete_invoices
        expect(incomplete_invoices_list).to eq([@invoice_for_customer_6, @invoice_for_customer_7])
      end
    end
  end

  describe "instance methods" do
    describe "#format_date" do
      it "formats created_at date to correct formatting" do
        customer = Customer.create!(first_name: "Joey", last_name: "Ondricka")
        invoice = Invoice.create!(customer_id: customer.id, status: 1, created_at: "2012-03-25 09:54:09 UTC")
        expect(invoice.format_date).to eq("Sunday, March 25, 2012")
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

        expect(invoice.total_revenue_for_invoice(merchant)).to eq(400)
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
        expect(invoice_A.total_revenue_for_invoice(merchant_A)).to eq(75)
        expect(invoice_A.total_discounted_revenue_for_invoice).to eq(75) # no discount applied, since one item was not ordered 10 times to meet the quantity threshold of bulk discount.

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
        expect(invoice_A.total_revenue_for_invoice(merchant_A)).to eq(125)
        expect(invoice_A.total_discounted_revenue_for_invoice).to eq(105.0)

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
        expect(invoice_A.total_revenue_for_invoice(merchant_A)).to eq(195)
        expect(invoice_A.total_discounted_revenue_for_invoice).to eq(148.5)

        # Item A meets the quantity threshold for Bulk Discount A: 120 - 20% = 96
        # Item B meets the quantity threshold for Bulk Discount B: 75 - 30% = 52.5
        # 96 + 52.5 = 148.5
      end

      # Example 4
      it "Both item_A and item_B should discounted at 20% off. Additionally, there is no scenario where bulk_discount_B can ever be applied" do
        # Merchant A has two Bulk Discounts, Bulk Discount A is 20% off 10 items, Bulk Discount B is 15% off 15 items
        merchant_A = create(:merchant, status: "enabled")
        bulk_discount_A = BulkDiscount.create!(name: "Bulk Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant_A.id)
        bulk_discount_B = BulkDiscount.create!(name: "Bulk Discount B", percentage: 15, quantity_threshold: 15, merchant_id: merchant_A.id)

        # Invoice A includes two of Merchant A’s items, Item A is ordered in a quantity of 12, Item B is ordered in a quantity of 15
        customer = Customer.create!(first_name: "First", last_name: "Customer")
        invoice_A = Invoice.create!(status: "completed", customer_id: customer.id)

        item_A = Item.create!(name: "Pencil", description: "The best pencil ever", unit_price: 10, status: 1, merchant_id: merchant_A.id)
        item_B = Item.create!(name: "Eraser", description: "The best eraser ever", unit_price: 5, status: 1, merchant_id: merchant_A.id)

        invoice_item_A = InvoiceItem.create!(quantity: 12, unit_price: item_A.unit_price, status: "shipped", item_id: item_A.id, invoice_id: invoice_A.id)
        invoice_item_B = InvoiceItem.create!(quantity: 15, unit_price: item_B.unit_price, status: "shipped", item_id: item_B.id, invoice_id: invoice_A.id)
        transaction = create(:transaction, result: "success", invoice_id: invoice_A.id)

        # Both Item A and Item B should discounted at 20% off. Additionally, there is no scenario where Bulk Discount B can ever be applied.
        expect(invoice_A.total_revenue_for_invoice(merchant_A)).to eq(195)
        expect(invoice_A.total_discounted_revenue_for_invoice).to eq(156.0)

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
        expect(invoice_A.total_revenue_for_invoice(merchant_A)).to eq(195)
        expect(invoice_A.total_discounted_revenue_for_invoice).to eq(223.5)
        # Item A1 meets the quantity threshold for Bulk Discount A: 12 x 10 = 120, 120 - 20% = 96
        # Item A2 meets the quantity threshold for Bulk Discount B: 15 x 5 = 75, 75 - 30% = 52.5
        # 96 + 52.5 + 75(cost of invoice_item_B without discount) = 148.5

        # Bulk discounts for one merchant should not affect items sold by another merchant. Item B should not be discounted.
        expect(invoice_A.total_revenue_for_invoice(merchant_B)).to eq(75) # no discount applied
      end
    end
  end
end
