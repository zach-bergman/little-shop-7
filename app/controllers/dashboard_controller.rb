class DashboardController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @ready_to_ship = @merchant.ready_to_ship
  end
end
