class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items.includes(:item)
    @total_revenue = @invoice.total_revenue
  end

  def update

    invoice = Invoice.find(params[:id])

    Invoice.update(status: params[:status])

    redirect_to admin_invoice_path(invoice.id)

    if @invoice = Invoice.find(params[:id])
      redirect_to admin_invoice_path(@invoice), notice: "Invoice status has been updated"
    else
      render :show
    end
  end
end