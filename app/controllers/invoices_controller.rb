class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @total_revenue = @merchant.total_revenue_for_invoice(@invoice)
    @total_discounted_revenue = @merchant.total_discounted_revenue_for_invoice(@invoice)
  end
end
