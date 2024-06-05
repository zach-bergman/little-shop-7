class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    merchant = Merchant.find(params[:merchant_id])
    invoice_item.update(invoice_item_params)
    flash[:notice] = 'Invoice status updated'
    redirect_to merchant_invoice_path(merchant, invoice_item.invoice)
  end

  private

  def invoice_item_params
    params.permit(:status)
  end
end