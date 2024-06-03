class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    @enabled_items = @items.where(status: 1)
    @disabled_items = @items.where(status: 0)
    @top_five_items = @merchant.top_five_items
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.create(item_params)
    redirect_to merchant_items_path(@merchant)
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if params.has_key?(:status)
      @item.update(status: params[:status])
      redirect_to merchant_items_path(@item.merchant)
    else
      @item.update(item_params)
      redirect_to merchant_item_path(@item.merchant, @item)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :status)
  end
end
