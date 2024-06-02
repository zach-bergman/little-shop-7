class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    redirect_to merchant_item_path(@item.merchant, @item)
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
