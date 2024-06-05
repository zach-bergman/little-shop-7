class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update 
    invoice = Invoice.find(params[:id])
    merchant = Merchant.find(params[:merchant_id])
    if invoice.update(invoice_params)
      flash[:success] = 'Invoice status updated'
    else
      flash[:error] = 'Invoice status not updated'
    end
    redirect_to merchant_invoice_path(merchant, invoice)
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  private

  def invoice_params
    params.permit(:status)
  end
end
