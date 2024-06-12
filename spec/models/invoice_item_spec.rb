require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
    it { should have_one :merchant }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe "validations" do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :status }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values({ 'pending' => 0, 'packaged' => 1, 'shipped' => 2 }) }
  end

  describe "instance methods" do
    describe "#applied_discount" do
      it "returns the correct bulk discount" do
        merchant = create(:merchant, status: "enabled")
        bulk_discount_1 = BulkDiscount.create!(name: "Bulk Discount 1", percentage: 20, quantity_threshold: 3, merchant_id: merchant.id)
        bulk_discount_2 = BulkDiscount.create!(name: "Bulk Discount 2", percentage: 10, quantity_threshold: 2, merchant_id: merchant.id)
        bulk_discount_3 = BulkDiscount.create!(name: "Bulk Discount 3", percentage: 20, quantity_threshold: 4, merchant_id: merchant.id)

        customer = create(:customer)
        invoice = create(:invoice, customer: customer)

        item_1 = create(:item, merchant: merchant, unit_price: 100)
        item_2 = create(:item, merchant: merchant, unit_price: 200)

        invoice_item_1 = create(:invoice_item, invoice: invoice, item: item_1, quantity: 3, unit_price: item_1.unit_price)
        invoice_item_2 = create(:invoice_item, invoice: invoice, item: item_2, quantity: 2, unit_price: item_2.unit_price)
        invoice_item_3 = create(:invoice_item, invoice: invoice, item: item_2, quantity: 1, unit_price: item_2.unit_price)

        expect(invoice_item_1.applied_discount).to eq(bulk_discount_1)
        expect(invoice_item_2.applied_discount).to eq(bulk_discount_2)
        expect(invoice_item_3.applied_discount).to eq(nil)
      end
    end
  end
end