class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])

    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)

    if bulk_discount.valid?
      bulk_discount.save

      redirect_to merchant_bulk_discounts_path(@merchant.id)
    else 
      flash[:alert] = "Error: #{bulk_discount.errors.full_messages.to_sentence}"

      redirect_to new_merchant_bulk_discount_path(@merchant.id)
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.find(params[:id])
    
    bulk_discount.destroy

    redirect_to merchant_bulk_discounts_path(merchant.id), notice: "Bulk discount was successfully deleted."
  end

  private
  def bulk_discount_params
    params.permit(:name, :percentage, :quantity_threshold)
  end
end