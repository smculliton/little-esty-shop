class MerchantDiscountsController < ApplicationController
  def self.controller_path
    'merchants/discounts'
  end

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end
end