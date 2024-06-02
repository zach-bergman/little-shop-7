class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items.includes(:item)
    @total_revenue = @invoice.invoice_items.sum { |item| item.quantity * item.unit_price}
  end
end