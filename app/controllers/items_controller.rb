class ItemsController < ApplicationController
  def index 
    @merchant = Merchant.find(params[:merchant_id])
    if params[:merchant_id]
      @merchant.items 
    end
  end

  def show
    # @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end
end