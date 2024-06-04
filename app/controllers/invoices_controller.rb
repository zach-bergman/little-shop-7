class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    invoice = Invoice.find(params[:id])
    if invoice.update(status: params[:status])
      flash[:success] = 'Invoice status updated'
    else
      flash[:error] = 'Invoice status not updated'
    end
    redirect_to merchant_invoice_path(invoice.merchant, invoice)
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end
end
