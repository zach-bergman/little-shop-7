require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :status }
  end

  describe 'instance methods' do
    describe 'best day' do
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

        @invoice_1 = create(:invoice, customer: @customer_1, status: 1, created_at: Date)
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
      end

      it 'displays the best day for each of the top five items' do
        expect(@item_1.best_day).to eq(@invoice_1.created_at.to_date)
      end
    end
  end
end
