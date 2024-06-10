class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @total_discounted_revenue_for_merchant = @invoice.total_discounted_revenue_for_invoice
    @bulk_discounts = @merchant.bulk_discounts
  end
end
